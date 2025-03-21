//
//  AppleLoginUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol AppleLoginUseCase {
    func login(identityToken token: String) async throws -> Token
}

public final class AppleLoginUseCaseImpl: AppleLoginUseCase {
    private let appleLoginRepository: AppleLoginRepository

    public init(appleLoginRepository: AppleLoginRepository) {
        self.appleLoginRepository = appleLoginRepository
    }

    public func login(identityToken token: String) async throws -> Token {
        return try await appleLoginRepository.login(identityToken: token)
    }
}
