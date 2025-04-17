//
//  SetOnboardingStatusUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol SetOnboardingStatusUseCase {
    func execute(_ required: Bool)
}

public final class SetOnboardingStatusUseCaseImpl: SetOnboardingStatusUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func execute(_ required: Bool) {
        userRepository.isOnboardingRequired = required
    }
}
