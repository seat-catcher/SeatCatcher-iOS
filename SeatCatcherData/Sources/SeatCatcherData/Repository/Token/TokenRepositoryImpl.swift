//
//  TokenRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/24/25.
//

import SeatCatcherDomain

public struct TokenRepositoryImpl: TokenRepository {
    // 키체인 접근 Key
    private let accessToken = "accessToken"
    private let refreshToken = "refreshToken"

    public init() {}

    // MARK: - AccessToken
    public func saveAccessToken(_ token: String) throws {
        try KeyChainService.save(token: token, key: accessToken)
    }
    public func getAccessToken() throws -> String? {
        return try KeyChainService.get(key: accessToken)
    }
    public func deleteAccessToken(_ token: String) throws {
        try KeyChainService.get(key: accessToken)
    }
    // MARK: - RefreshToken
    public func saveRefreshToken(_ token: String) throws {
        try KeyChainService.save(token: token, key: refreshToken)
    }
    public func getRefreshToken() throws -> String? {
        return try KeyChainService.get(key: refreshToken)
    }
    public func deleteRefreshToken(_ token: String) throws {
        try KeyChainService.get(key: refreshToken)
    }
}
