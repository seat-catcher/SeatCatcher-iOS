//
//  TokenRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/24/25.
//

public protocol TokenRepository {
    func saveAccessToken(_ token: String) throws
    func getAccessToken() throws -> String?
    func deleteAccessToken(_ token: String) throws

    func saveRefreshToken(_ token: String) throws
    func getRefreshToken() throws -> String?
    func deleteRefreshToken(_ token: String) throws
}
