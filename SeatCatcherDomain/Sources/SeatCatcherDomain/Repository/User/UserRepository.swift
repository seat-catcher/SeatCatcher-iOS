//
//  UserRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/29/25.
//

public protocol UserRepository {
    func fetchRandomNickname() async throws -> String
    func saveUserInfo(nickname: String, tag: Int) async throws
}
