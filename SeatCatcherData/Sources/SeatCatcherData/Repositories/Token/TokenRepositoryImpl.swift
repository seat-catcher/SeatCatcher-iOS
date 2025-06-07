//
//  TokenRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/24/25.
//

import Combine
import SeatCatcherDomain

public final class TokenRepositoryImpl: TokenRepository {
    enum TokenError: Error {
        case accessTokenNotFoundInKeychain
        case refreshTokenNotFoundInKeychain
    }

    // 키체인 접근 Key
    private let accessToken = "accessToken"
    private let refreshToken = "refreshToken"

    private let networkService: NetworkService

    private let accessTokenSubject = PassthroughSubject<String, Never>()

    public var accessTokenPublisher: AnyPublisher<String, Never> {
        accessTokenSubject.eraseToAnyPublisher()
    }

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    public func reissue() async throws -> Token {
        guard let refreshToken = try getRefreshToken() else { throw TokenError.refreshTokenNotFoundInKeychain }
        let responseDTO = try await networkService.postRefreshToken()
        return responseDTO.domainModel
    }
    
    public func getTokenValidStatus() async throws {
        guard let accessToken = try getAccessToken() else { throw TokenError.accessTokenNotFoundInKeychain }
        #if DEBUG
        dump(accessToken)
        #endif
        try await networkService.getAccessTokenValidStatus()
    }

    // MARK: - AccessToken
    public func saveAccessToken(_ token: String) throws {
        // Swagger Authorize를 위해 액세스토큰 저장 시 로그 출력하도록 남겨놓았습니다.
        try KeychainService.save(token: token, key: accessToken)
        accessTokenSubject.send(token)
    }
    public func getAccessToken() throws -> String? {
        return try KeychainService.get(key: accessToken)
    }
    public func deleteAccessToken() throws {
        try KeychainService.delete(key: accessToken)
    }
    // MARK: - RefreshToken
    public func saveRefreshToken(_ token: String) throws {
        try KeychainService.save(token: token, key: refreshToken)
    }
    public func getRefreshToken() throws -> String? {
        return try KeychainService.get(key: refreshToken)
    }
    public func deleteRefreshToken() throws {
        try KeychainService.delete(key: refreshToken)
    }

    public func saveTokens(_ token: Token) throws {
        try saveAccessToken(token.accessToken)
        try saveRefreshToken(token.refreshToken)
    }

    public func deleteTokens() throws {
        try deleteAccessToken()
        try deleteRefreshToken()
    }
}
