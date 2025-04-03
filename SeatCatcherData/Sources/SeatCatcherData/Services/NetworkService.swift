//
//  NetworkService.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/24/25.
//

import Foundation
import Alamofire
import Moya

struct NetworkService {
    /// _AuthInterceptor는 Alamofire의 RequestInterceptor 프로토콜을 채택하여,
    /// HTTP 응답이 401(Unauthorized)일 때 토큰 리이슈를 시도하고, 그 결과에 따라 요청을 재시도할지 결정하는 역할을 합니다.
    struct _AuthInterceptor: RequestInterceptor {

        /// _CompletionWrapper는 non‑Sendable인 completion 클로저를 @unchecked Sendable로 감싸기 위한 래퍼 타입입니다.
        /// retry 메소드의 completion 클로저가 내부에서 별도의 mutable한 상태를 캡처하거나 변경하지 않고,
        /// 오직 retry 메소드 내부에서만 사용되며,
        /// Alamofire의 RetryResult는 Enum으로 값 복사가 일어나 별도의 mutable state를 만들지 않기 때문에
        /// 공유 상태가 일어나지 않는다고 판단했고, Sendable 준수에 대한 컴파일 에러를 우회하기 위해 @unchecked Sendable로 래핑했습니다.
        /// 컴파일러 에러를 우회한 상태이므로, 추후 로직 추가 시 스레드 안전성이 보장되지 않는 상황이라도 에러를 발생시키지 않기 때문에 주의가 필요합니다.
        struct _CompletionWrapper: @unchecked Sendable {
            /// 원래의 completion 클로저를 저장합니다.
            let closure: (RetryResult) -> Void

            /// 전달받은 RetryResult를 가지고 저장된 클로저를 호출합니다.
            func call(with result: RetryResult) {
                closure(result)
            }
        }

        /// Alamofire의 retry 메소드 구현.
        /// HTTP 응답이 401이고, URL 경로에 "refresh"가 포함되어 있지 않을 때 토큰 리이슈를 시도합니다.
        func retry(
            _ request: Request,
            for session: Session,
            dueTo error: any Error,
            completion: @escaping (RetryResult) -> Void
        ) {
            // 401 응답인지 검사, 아니라면 retry 없이 return
            guard let response = request.task?.response as? HTTPURLResponse,
                  response.statusCode == 401
            else {
                dump("HTTP Request Failed")
                completion(.doNotRetryWithError(error))
                return
            }

            // reissue 엔드포인트("/token/refresh")로부터 온 응답이 아닌지 검사
            // reissue 엔드포인트로부터 온 응답이라면 로그아웃
            guard let pathComponents = request.request?.url?.pathComponents,
                      !pathComponents.contains("refresh")
            else {
                completion(.doNotRetryWithError(error))
                dump("HTTP Request Failed | 리프레시 토큰 만료, 로그아웃")

                // 키체인에 저장된 토큰을 삭제합니다.
                let tokenRepository = TokenRepositoryImpl()
                try? tokenRepository.deleteTokens()

                // 로그인 상태를 false로 설정하여, 사용자를 로그아웃시킵니다.
                UserDefaults.standard.set(false, forKey: "isSignedIn")
                return
            }

            // 전달받은 completion 클로저를 _CompletionWrapper로 래핑합니다.
            let completion = _CompletionWrapper(closure: completion)

            // 토큰 리이슈를 위해 TokenRepositoryImpl의 인스턴스를 생성합니다.
            // 내부에 Stored Property로 저장할 경우 RequestInterceptor의 Sendable을 충족하지 못하므로,
            // 블록 내부 지역 변수로 선언합니다.
            let tokenRepository = TokenRepositoryImpl()

            // 비동기 Task를 생성하여 토큰 리이슈 작업을 실행합니다.
            _Concurrency.Task {
                do {
                    dump("HTTP Request Failed | 토큰 리이슈")
                    // 토큰을 새로 갱신합니다.
                    let token = try await tokenRepository.reissue()
                    try tokenRepository.saveTokens(token)
                    dump("HTTP Request Failed | 토큰 갱신 성공, 재시도")
                    // 토큰 갱신에 성공하면 completion 클로저에 .retry를 전달하여 요청 재시도를 알립니다.
                    completion.call(with: .retry)
                } catch {
                    dump("HTTP Request Failed | 토큰 갱신 실패, 로그아웃")
                    // 토큰 갱신에 실패하면 completion 클로저에 실패 결과를 전달합니다.
                    completion.call(with: .doNotRetryWithError(error))

                    // 키체인에 저장된 토큰을 삭제합니다.
                    let tokenRepository = TokenRepositoryImpl()
                    try? tokenRepository.deleteTokens()

                    // 로그인 상태를 false로 설정하여, 사용자를 로그아웃시킵니다.
                    UserDefaults.standard.set(false, forKey: "isSignedIn")
                    return
                }
            }
        }
    }

    enum DecodingError: Error {
        case plaintextDecodingError
    }

    private let provider = MoyaProvider<SeatCatcherAPI>(session: Session(interceptor: _AuthInterceptor()))

    func postAppleLogin(_ token: String) async throws -> AppleLoginResponseDTO {
        let requestDTO = AppleLoginRequestDTO(identityToken: token)
        let response = try await provider.request(.postSignInWithApple(requestDTO))
        let responseDTO = try JSONDecoder().decode(AppleLoginResponseDTO.self, from: response)
        return responseDTO
    }

    func postKakaoLogin(_ token: String) async throws -> KakaoLoginResponseDTO {
        let requestDTO = KakaoLoginRequestDTO(accessToken: token)
        let response = try await provider.request(.postSignInWithKakao(requestDTO))
        let responseDTO = try JSONDecoder().decode(KakaoLoginResponseDTO.self, from: response)
        return responseDTO
    }

    func postRefreshToken(_ refreshToken: String) async throws -> RefreshTokenResponseDTO {
        let requestDTO = RefreshTokenRequestDTO(refreshToken: refreshToken)
        let response = try await provider.request(.postRefreshToken(requestDTO))
        let responseDTO = try JSONDecoder().decode(RefreshTokenResponseDTO.self, from: response)
        return responseDTO
    }

    func getAccessTokenValidStatus(_ accessToken: String) async throws {
        try await provider.request(.getAccessTokenValidStatus(accessToken))
    }
}
