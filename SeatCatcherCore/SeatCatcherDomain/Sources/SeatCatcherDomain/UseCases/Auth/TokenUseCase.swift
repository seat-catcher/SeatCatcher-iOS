//
//  TokenUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/24/25.
//

public protocol TokenUseCase {
    func saveAccessToken(_ token: String) throws
    func getAccessToken() throws -> String?
    func deleteAccessToken(_ token: String) throws

    func saveRefreshToken(_ token: String) throws
    func getRefreshToken() throws -> String?
    func deleteRefreshToken(_ token: String) throws
}

public final class TokenUseCaseImpl: TokenUseCase {
    let tokenRepository: TokenRepository

    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    // MARK: - AccessToken
    public func saveAccessToken(_ token: String) throws {
        try tokenRepository.saveAccessToken(token)
    }
    public func getAccessToken() throws -> String? {
        return try tokenRepository.getAccessToken()
    }
    public func deleteAccessToken(_ token: String) throws {
        try tokenRepository.deleteAccessToken(token)
    }
    // MARK: - RefreshToken
    public func saveRefreshToken(_ token: String) throws {
        try tokenRepository.saveRefreshToken(token)
    }
    public func getRefreshToken() throws -> String? {
        return try tokenRepository.getRefreshToken()
    }
    public func deleteRefreshToken(_ token: String) throws {
        try tokenRepository.deleteRefreshToken(token)
    }
}
