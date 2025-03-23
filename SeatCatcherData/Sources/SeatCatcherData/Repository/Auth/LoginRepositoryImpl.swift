//
//  AppleLoginRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/19/25.
//

import Foundation
import SeatCatcherDomain
import Moya
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

public final class LoginRepositoryImpl: LoginRepository {
    enum KakaoLoginError: Error {
        case tokenNotFound
        case loginNotAvailable
    }
    
    private let provider = MoyaProvider<SeatCatcherAPI>()

    public init() {}

    public func appleLogin(identityToken token: String) async throws -> SeatCatcherDomain.Token {
        let requestDTO = AppleLoginRequestDTO(identityToken: token)
        let response = try await provider.request(.postSignInWithApple(requestDTO))
        let responseDTO = try JSONDecoder().decode(AppleLoginResponseDTO.self, from: response)
        return responseDTO.toEntity()
    }

    public func kakaoLogin() async throws -> SeatCatcherDomain.Token {
        let accessToken = try await getKakaoLoginAccessToken()
        let requestDTO = KakaoLoginRequestDTO(accessToken: accessToken)
        let response = try await provider.request(.postSignInWithKakao(requestDTO))
        let responseDTO = try JSONDecoder().decode(KakaoLoginResponseDTO.self, from: response)
        return responseDTO.toEntity()
    }

    /// - 카카오톡에서 카카오 로그인 후 토큰 정보를 가져오는 메소드입니다.
    /// - 카카오 SDK의 UserApi.shared,loginWithKakaoTalk이 GCD 기반이기 때문에, Swift Concurrency 기반으로 관리하기 위해 accessToken을 받아오는 메소드를 작성해 매핑했습니다.
    private func getKakaoLoginAccessToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            // 카카오 로그인 시 카카오톡 앱 실행 -> UI 변경이므로 Main Thread 실행 보장
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let token = oauthToken?.accessToken {
                            continuation.resume(returning: token)
                        } else {
                            continuation.resume(throwing: KakaoLoginError.tokenNotFound)
                        }
                    }
                } else {
                    continuation.resume(throwing: KakaoLoginError.loginNotAvailable)
                }
            }
        }
    }
}
