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
    func reissueAndSaveToken() async throws
    func isAccessTokenValid() async throws
    func logout() throws
}

public final class AuthUseCaseImpl: AuthUseCase {
    private let loginRepository: LoginRepository
    private let tokenRepository: TokenRepository

    public init(
        loginRepository: LoginRepository,
        tokenRepository: TokenRepository
    ) {
        self.loginRepository = loginRepository
        self.tokenRepository = tokenRepository
    }

    public func appleLogin(identityToken token: String) async throws {
        let token = try await loginRepository.appleLogin(identityToken: token)
        try tokenRepository.saveTokens(token)
        UserDefaults.standard.set(true, forKey: "isSignedIn")
    }

    public func kakaoLogin() async throws {
        let token = try await loginRepository.kakaoLogin()
        try tokenRepository.saveTokens(token)
        UserDefaults.standard.set(true, forKey: "isSignedIn")
    }

    public func reissueAndSaveToken() async throws {
        let token = try await tokenRepository.reissue()
        try tokenRepository.saveTokens(token)
    }

    public func isAccessTokenValid() async throws {
        try await tokenRepository.getTokenValidStatus()
    }

    public func logout() throws {
        try tokenRepository.deleteTokens()
        UserDefaults.standard.set(false, forKey: "isSignedIn")
    }
}
