//
//  NetworkService.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/24/25.
//

import Foundation
import Moya

final class NetworkService {
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
}
