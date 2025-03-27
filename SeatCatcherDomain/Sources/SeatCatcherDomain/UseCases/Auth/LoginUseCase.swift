//
//  AppleLoginUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol LoginUseCase {
    // MARK: - 로그인
    func appleLogin(identityToken token: String) async throws -> Token
    func kakaoLogin() async throws -> Token

    // MARK: - 토큰
    func saveAccessToken(_ token: String) throws
    func getAccessToken() throws -> String?
    func deleteAccessToken() throws

    func saveRefreshToken(_ token: String) throws
    func getRefreshToken() throws -> String?
    func deleteRefreshToken() throws
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

    public func appleLogin(identityToken token: String) async throws -> Token {
        return try await loginRepository.appleLogin(identityToken: token)
    }

    public func kakaoLogin() async throws -> Token {
        return try await loginRepository.kakaoLogin()
    }

    // MARK: - AccessToken
    public func saveAccessToken(_ token: String) throws {
        try tokenRepository.saveAccessToken(token)
    }
    public func getAccessToken() throws -> String? {
        return try tokenRepository.getAccessToken()
    }
    public func deleteAccessToken() throws {
        try tokenRepository.deleteAccessToken()
    }
    
    // MARK: - RefreshToken
    public func saveRefreshToken(_ token: String) throws {
        try tokenRepository.saveRefreshToken(token)
    }
    public func getRefreshToken() throws -> String? {
        return try tokenRepository.getRefreshToken()
    }
    public func deleteRefreshToken() throws {
        try tokenRepository.deleteRefreshToken()
    }
}
