//
//  GetUserInfoUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol GetUserInfoUseCase {
    func execute() async throws -> User
}

public final class GetUserInfoUseCaseImpl: GetUserInfoUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func execute() async throws -> User {
        return try await userRepository.getUser()
    }
}
