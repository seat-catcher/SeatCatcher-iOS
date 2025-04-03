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

    struct _AuthInterceptor: RequestInterceptor {

        struct _CompletionWrapper: @unchecked Sendable {
            let closure: (RetryResult) -> Void
            func call(with result: RetryResult) {
                closure(result)
            }
        }

        func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, let pathComponents =
                    request.request?.url?.pathComponents,
                    !pathComponents.contains("refresh")
            else {
                dump("donotretry")
                completion(.doNotRetryWithError(error))
                return
            }
            let completion = _CompletionWrapper(closure: completion)
            let tokenRepository = TokenRepositoryImpl()
            _Concurrency.Task {
                do {
                    let token = try await tokenRepository.refreshTokens()
                    completion.call(with: .retry)
                } catch {
                    completion.call(with: .doNotRetryWithError(error))
                    UserDefaults.standard.set(false, forKey: "isSignedIn")
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

    func getAccessTokenValidStatus(_ accessToken: String) async throws -> String {
        let response = try await provider.request(.getAccessTokenValidStatus(accessToken))

        guard let decodedResponse = String(data: response, encoding: .utf8) else { throw DecodingError.plaintextDecodingError }
        return decodedResponse
    }
}
