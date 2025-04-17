//
//  ValidateTokenUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol ValidateTokenUseCase {
    func execute() async throws
}

public final class ValidateTokenUseCaseImpl: ValidateTokenUseCase {
    private let tokenRepository: TokenRepository

    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }

    public func execute() async throws {
        try await tokenRepository.getTokenValidStatus()
    }
}
