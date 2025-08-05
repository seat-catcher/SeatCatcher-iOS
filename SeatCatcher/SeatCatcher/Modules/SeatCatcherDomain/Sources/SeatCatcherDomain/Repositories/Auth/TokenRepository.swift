//
//  TokenRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/24/25.
//

import Combine

public protocol TokenRepository: AnyObject {
    var accessTokenPublisher: AnyPublisher<String, Never> { get }

    func reissue() async throws -> Token
    func getTokenValidStatus() async throws

    func saveAccessToken(_ token: String) throws
    func getAccessToken() throws -> String?
    func deleteAccessToken() throws

    func saveRefreshToken(_ token: String) throws
    func getRefreshToken() throws -> String?
    func deleteRefreshToken() throws
    
    func saveFCMToken(_ token: String) throws
    func getFCMToken() throws -> String?
    func deleteFCMToken() throws

    func saveTokens(_ token: Token) throws
    func deleteTokens() throws
}
