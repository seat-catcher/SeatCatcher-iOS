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

    private let networkService: NetworkService

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    public func getRandomNickname() -> String {
        return NicknameDataSource.randomNickname
    }

    public func getRandomUserImage() -> UserImage {
        return UserImage.allCases.randomElement() ?? .catchy1
    }

    public func getUser() async throws -> User {
        let dto = try await networkService.getUser()
        return dto.domainModel
    }

    public func patchUser(user: User) async throws -> User {
        let dto = try await networkService.patchUser(user)
        return dto.domainModel
    }
    
    public func withdraw() async throws {
        try await networkService.withdraw()
    }
}
