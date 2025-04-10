//
//  TokenRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/24/25.
//

public protocol TokenRepository: AnyObject {
    func reissue() async throws -> TokenVO
    func getTokenValidStatus() async throws

    func saveAccessToken(_ token: String) throws
    func getAccessToken() throws -> String?
    func deleteAccessToken() throws

    func saveRefreshToken(_ token: String) throws
    func getRefreshToken() throws -> String?
    func deleteRefreshToken() throws

    func saveTokens(_ token: TokenVO) throws
    func deleteTokens() throws
}
