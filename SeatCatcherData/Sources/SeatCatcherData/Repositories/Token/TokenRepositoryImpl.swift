//
//  TokenRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/24/25.
//

import SeatCatcherDomain

public struct TokenRepositoryImpl: TokenRepository {
    enum TokenError: Error {
        case accessTokenNotFoundInKeychain
        case refreshTokenNotFoundInKeychain
    }

    // 키체인 접근 Key
    private let accessToken = "accessToken"
    private let refreshToken = "refreshToken"

    private let networkService = NetworkService()

    public init() {}

    public func refreshTokens() async throws -> TokenVO {
        guard let refreshToken = try getRefreshToken() else { throw TokenError.refreshTokenNotFoundInKeychain }
        let responseDTO = try await networkService.postRefreshToken(refreshToken)
        return responseDTO.domainModel
    }
    
    public func getTokenValidStatus() async throws -> Bool {
        guard let accessToken = try getAccessToken() else { throw TokenError.accessTokenNotFoundInKeychain }
        let responsePlainText = try await networkService.getAccessTokenValidStatus(accessToken)
        return responsePlainText == "Valid" ? true : false
    }

    // MARK: - AccessToken
    public func saveAccessToken(_ token: String) throws {
        try KeychainService.save(token: token, key: accessToken)
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
}
