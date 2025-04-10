//
//  UserRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/29/25.
//

import SeatCatcherDomain

public final class UserRepositoryImpl: UserRepository {
    public var isSignedIn: Bool {
        get { UserDefaultsService.isSignedIn }
        set { UserDefaultsService.isSignedIn = newValue }
    }

    public var isOnboardingRequired: Bool {
        get { UserDefaultsService.isOnboardingRequired }
        set { UserDefaultsService.isOnboardingRequired = newValue }
    }

    public init() {}

    public func fetchRandomNickname() async throws -> String {
        let dto = NicknameResponseDTO.stub
        try await Task.sleep(for: .seconds(0.2))
        return dto.domainModel
    }

    public func saveUserInfo(nickname: String, tag: UserTag) async throws -> Bool {
        let dto = SaveUserInfoResponseDTO.stub
        try await Task.sleep(for: .seconds(0.2))
        return dto.domainModel
    }
}
