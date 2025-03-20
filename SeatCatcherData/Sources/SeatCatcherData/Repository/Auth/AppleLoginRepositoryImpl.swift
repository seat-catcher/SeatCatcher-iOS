//
//  AppleLoginRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/19/25.
//

import Foundation
import SeatCatcherDomain
import Moya

public final class AppleLoginRepositoryImpl: AppleLoginRepository {
    private let provider = MoyaProvider<SeatCatcherAPI>()

    public init() {}

    public func login(identityToken token: String) async throws -> Token? {
        let requestDTO = AppleLoginRequestDTO(identityToken: token)
        dump(requestDTO)
        let response = try await provider.request(.postSignInWithApple(requestDTO))
        let responseDTO = try JSONDecoder().decode(AppleLoginResponseDTO.self, from: response)
        return responseDTO.toEntity()
    }
}
