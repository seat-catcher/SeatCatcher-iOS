//
//  AppleLoginUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol LoginUseCase {
    // MARK: - 로그인
    func appleLogin(identityToken token: String) async throws
    func kakaoLogin() async throws
}

public final class LoginUseCaseImpl: LoginUseCase {
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
        try saveAccessToken(token.accessToken)
        try saveRefreshToken(token.refreshToken)
    }

    public func kakaoLogin() async throws {
        let token = try await loginRepository.kakaoLogin()
        try saveAccessToken(token.accessToken)
        try saveRefreshToken(token.refreshToken)
    }

    // MARK: - AccessToken
    private func saveAccessToken(_ token: String) throws {
        try tokenRepository.saveAccessToken(token)
    }
    
    // MARK: - RefreshToken
    private func saveRefreshToken(_ token: String) throws {
        try tokenRepository.saveRefreshToken(token)
    }
}
