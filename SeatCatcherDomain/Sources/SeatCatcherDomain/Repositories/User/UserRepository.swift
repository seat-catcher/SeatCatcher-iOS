//
//  UserRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/29/25.
//

public protocol UserRepository: AnyObject {
    var isSignedIn: Bool { get set }
    var isOnboardingRequired: Bool { get set }

    func fetchRandomNickname() async throws -> String
    func saveUserInfo(nickname: String, tag: UserTag) async throws -> Bool
}
