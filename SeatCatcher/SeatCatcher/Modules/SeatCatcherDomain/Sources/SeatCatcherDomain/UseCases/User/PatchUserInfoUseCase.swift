//
//  PatchUserInfoUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol PatchUserInfoUseCase {
    @discardableResult
    func execute(_ user: User) async throws -> User
}

public final class PatchUserInfoUseCaseImpl: PatchUserInfoUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func execute(_ user: User) async throws -> User {
        let user = try await userRepository.patchUser(user: user)
        return user
    }
}
