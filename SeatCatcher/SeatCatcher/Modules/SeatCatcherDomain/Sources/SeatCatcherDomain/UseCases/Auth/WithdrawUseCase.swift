//
//  WithdrawUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 8/15/25.
//

import Foundation

public protocol WithdrawUseCase {
    func execute() async throws
}

public final class WithdrawUseCaseImpl: WithdrawUseCase {
    private let tokenRepository: TokenRepository
    private let userRepository: UserRepository

    public init(
        tokenRepository: TokenRepository,
        userRepository: UserRepository
    ) {
        self.tokenRepository = tokenRepository
        self.userRepository = userRepository
    }
    
    public func execute() async throws {
        try await userRepository.withdraw()        
        userRepository.isSignedIn = false
        try tokenRepository.deleteTokens()
    }
}
