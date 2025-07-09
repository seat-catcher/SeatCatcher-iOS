//
//  GetRandomNicknameUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol GetRandomNicknameUseCase {
    func execute() -> String
}

public final class GetRandomNicknameUseCaseImpl: GetRandomNicknameUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func execute() -> String {
        return userRepository.getRandomNickname()
    }
}
