//
//  GetRandomUserImageUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol GetRandomUserImageUseCase {
    func execute() -> UserImage
}

public final class GetRandomUserImageUseCaseImpl: GetRandomUserImageUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func execute() -> UserImage {
        return userRepository.getRandomUserImage()
    }
}
