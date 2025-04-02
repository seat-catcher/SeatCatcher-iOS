//
//  NetworkService.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/24/25.
//

import Foundation
import Moya

final class NetworkService {
    enum DecodingError: Error {
        case plaintextDecodingError
    }

    private let provider = MoyaProvider<SeatCatcherAPI>()

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
