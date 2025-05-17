//
//  KakaoLoginUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol KakaoLoginUseCase {
    func execute() async throws
}

public final class KakaoLoginUseCaseImpl: KakaoLoginUseCase {
    private let loginRepository: LoginRepository
    private let tokenRepository: TokenRepository
    private let userRepository: UserRepository

    public init(
        loginRepository: LoginRepository,
        tokenRepository: TokenRepository,
        userRepository: UserRepository
    ) {
        self.loginRepository = loginRepository
        self.tokenRepository = tokenRepository
        self.userRepository = userRepository
    }

    public func execute() async throws {
        let token = try await loginRepository.kakaoLogin()
        try tokenRepository.saveTokens(token)
        userRepository.isSignedIn = true
    }
}
