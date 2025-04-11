//
//  NetworkService.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/24/25.
//

import Foundation
import Alamofire
import Moya
import SeatCatcherDomain

struct NetworkService {
    enum TokenError: Error {
        case accessTokenIsNil
    }

    /// _AuthInterceptor는 Alamofire의 RequestInterceptor 프로토콜을 채택하여,
    /// HTTP 응답이 401(Unauthorized)일 때 토큰 리이슈를 시도하고, 그 결과에 따라 요청을 재시도할지 결정하는 역할을 합니다.
    private struct AuthInterceptor: RequestInterceptor {

        /// Alamofire의 RequestInterceptor 프로토콜을 채택한 _AuthInterceptor의 adapt 메소드입니다.
        /// 이 메소드는 HTTP 요청을 보낼 때 호출되며,
        /// 만약 UserDefaults에 "isTokenRefreshed" 값이 true로 설정되어 있다면,
        /// 새롭게 갱신된 토큰을 사용해 Authorization 헤더를 업데이트한 후 수정된 URLRequest를 반환합니다.
        func adapt(
            _ urlRequest: URLRequest,
            for session: Session,
            completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void
        ) {
            // UserDefaults에서 "isTokenRefreshed" 플래그를 읽습니다.
            // 이 값은 이전에 토큰 리이슈 작업이 성공했음을 나타내며, 새 토큰을 적용해야 함을 의미합니다.

            // 만약 토큰이 새로 갱신된 상태라면, HTTP 헤더의 Authorization 값을 갱신합니다.
            if UserDefaultsService.isTokenRefreshed {
                // 새로운 토큰을 가져오기 위해 TokenRepositoryImpl 인스턴스를 생성합니다.
                let tokenRepository = TokenRepositoryImpl()
                // urlRequest를 복사하여 수정할 새 변수에 저장합니다.
                var urlRequestWithReissuedToken = urlRequest
                // 재시도 후에는 "isTokenRefreshed" 플래그를 false로 리셋합니다.
                UserDefaultsService.isTokenRefreshed = false

                do {
                    // TokenRepositoryImpl에서 액세스 토큰을 가져옵니다.
                    // 토큰이 nil인 경우 에러를 던집니다.
                    guard let accessToken = try tokenRepository.getAccessToken() else {
                        completion(.failure(TokenError.accessTokenIsNil))
                        throw TokenError.accessTokenIsNil
                    }
                    // "Authorization" 헤더에 "Bearer <accessToken>" 형식으로 값을 설정합니다.
                    urlRequestWithReissuedToken.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

                    dump("HTTP Request Failed | HTTP Authorization 헤더 AccessToken 교체 후 재시도")
                    // 수정된 URLRequest를 성공 결과로 반환합니다.
                    completion(.success(urlRequestWithReissuedToken))
                } catch {
                    dump("HTTP Request Failed | AccessToken Not Found")
                    // 토큰을 가져오거나 수정하는 중 에러가 발생하면 로그아웃합니다.
                    completion(.failure(error))
                    logout(tokenRepository: tokenRepository)
                }
            } else {
                // 만약 "isTokenRefreshed" 플래그가 false이면, 원본 URLRequest를 그대로 반환합니다.
                completion(.success(urlRequest))
            }
        }

        /// Alamofire의 retry 메소드 구현.
        /// HTTP 응답이 401이고, URL 경로에 "refresh"가 포함되어 있지 않을 때 토큰 리이슈를 시도합니다.
        func retry(
            _ request: Request,
            for session: Session,
            dueTo error: any Error,
            completion: @escaping @Sendable (RetryResult) -> Void
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

                // 키체인에 저장된 토큰을 삭제하고 로그아웃합니다.
                let tokenRepository = TokenRepositoryImpl()
                logout(tokenRepository: tokenRepository)
                return
            }

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
                    UserDefaultsService.isTokenRefreshed = true
                    dump("HTTP Request Failed | 토큰 갱신 성공, 재시도")
                    // 토큰 갱신에 성공하면 completion 클로저에 .retry를 전달하여 요청 재시도를 알립니다.
                    completion(.retry)
                } catch {
                    dump("HTTP Request Failed | 토큰 갱신 실패, 로그아웃")
                    // 토큰 갱신에 실패하면 completion 클로저에 실패 결과를 전달합니다.
                    completion(.doNotRetryWithError(error))

                    // 키체인에 저장된 토큰을 삭제하고 로그아웃합니다.
                    logout(tokenRepository: tokenRepository)
                }
            }
        }

        private func logout(tokenRepository: TokenRepository) {
            try? tokenRepository.deleteTokens()
            UserDefaultsService.isSignedIn = false
        }
    }

    enum DecodingError: Error {
        case plaintextDecodingError
    }

    private let provider = MoyaProvider<SeatCatcherAPI>(session: Session(interceptor: AuthInterceptor()))
    private var accessToken: String { (try? KeychainService.get(key: "accessToken")) ?? "" }
    private var refreshToken: String { (try? KeychainService.get(key: "refreshToken")) ?? "" }

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

    func postRefreshToken() async throws -> RefreshTokenResponseDTO {
        let requestDTO = RefreshTokenRequestDTO(refreshToken: refreshToken)
        let response = try await provider.request(.postRefreshToken(requestDTO))
        let responseDTO = try JSONDecoder().decode(RefreshTokenResponseDTO.self, from: response)
        return responseDTO
    }

    func getAccessTokenValidStatus() async throws {
        try await provider.request(.getAccessTokenValidStatus(accessToken))
    }

    func getUser() async throws -> GetUserResponseDTO {
        let response = try await provider.request(.getUser(accessToken: accessToken))
        let responseDTO = try JSONDecoder().decode(GetUserResponseDTO.self, from: response)
        return responseDTO
    }

    func patchUser(_ user: User) async throws -> PatchUserResponseDTO {
        let requestDTO = PatchUserRequestDTO(
            name: user.name,
            profileImageNum: user.profileImage.rawValue,
            tags: user.tags.compactMap { $0.rawValue },
            credit: user.credit)
        let response = try await provider.request(.patchUser(requestDTO, accessToken: accessToken))
        let responseDTO = try JSONDecoder().decode(PatchUserResponseDTO.self, from: response)
        return responseDTO
    }
}
