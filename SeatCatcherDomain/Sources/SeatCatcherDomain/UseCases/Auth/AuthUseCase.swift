//
//  AuthUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol AuthUseCase {
    // MARK: - 로그인
    func appleLogin(identityToken token: String) async throws
    func kakaoLogin() async throws
    func isAccessTokenValid() async throws
    func logout() throws
}

public final class AuthUseCaseImpl: AuthUseCase {
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

    public func appleLogin(identityToken token: String) async throws {
        let token = try await loginRepository.appleLogin(identityToken: token)
        try tokenRepository.saveTokens(token)
        userRepository.isSignedIn = true
    }

    public func kakaoLogin() async throws {
        let token = try await loginRepository.kakaoLogin()
        try tokenRepository.saveTokens(token)
        userRepository.isSignedIn = true
    }

    public func isAccessTokenValid() async throws {
        try await tokenRepository.getTokenValidStatus()
    }

    public func logout() throws {
        userRepository.isSignedIn = false
        try tokenRepository.deleteTokens()
    }
}
