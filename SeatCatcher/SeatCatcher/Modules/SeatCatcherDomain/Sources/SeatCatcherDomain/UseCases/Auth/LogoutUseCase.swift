//
//  LogoutUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol LogoutUseCase {
    func execute() throws
}

public final class LogoutUseCaseImpl: LogoutUseCase {
    private let tokenRepository: TokenRepository
    private let userRepository: UserRepository

    public init(
        tokenRepository: TokenRepository,
        userRepository: UserRepository
    ) {
        self.tokenRepository = tokenRepository
        self.userRepository = userRepository
    }

    public func execute() throws {
        userRepository.isSignedIn = false
        try tokenRepository.deleteTokens()
    }
}
