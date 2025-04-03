//
//  UserUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/29/25.
//

import Foundation

public protocol UserUseCase {
    func getRandomNickname() async throws -> String
    func saveUserInfo(nickname: String, tag: Int) async throws -> Bool
    func setOnboardingRequiredStatus(_ status: Bool)
    func setUserInfoRequiredStatus(_ status: Bool)
}

public final class UserUseCaseImpl: UserUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func getRandomNickname() async throws -> String {
        let nickname = try await userRepository.fetchRandomNickname()
        return nickname
    }

    public func saveUserInfo(nickname: String, tag: Int) async throws -> Bool {
        let result = try await userRepository.saveUserInfo(nickname: nickname, tag: tag)
        return result
    }

    public func setOnboardingRequiredStatus(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: "isOnboardingRequired")
    }

    public func setUserInfoRequiredStatus(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: "isUserInfoRequired")
    }
}
