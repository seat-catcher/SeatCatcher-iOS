//
//  AppleLoginUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol AppleLoginUseCase {
    func execute(identityToken token: String, authorizationCode: String) async throws
}

public final class AppleLoginUseCaseImpl: AppleLoginUseCase {
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

    public func execute(identityToken token: String, authorizationCode: String) async throws {
        let fcmToken = try tokenRepository.getFCMToken()
        let token = try await loginRepository.appleLogin(identityToken: token, fcmToken: fcmToken ?? "", authorizationCode: authorizationCode)
        try tokenRepository.saveTokens(token)
        userRepository.isSignedIn = true
    }
}
