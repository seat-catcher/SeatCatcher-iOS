//
//  UserRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/29/25.
//

public protocol UserRepository: AnyObject {
    var isSignedIn: Bool { get set }
    var isOnboardingRequired: Bool { get set }

    func getRandomNickname() -> String
    func getRandomUserImage() -> UserImage
    func getUser() async throws -> User
    func patchUser(user: User) async throws -> User
}
