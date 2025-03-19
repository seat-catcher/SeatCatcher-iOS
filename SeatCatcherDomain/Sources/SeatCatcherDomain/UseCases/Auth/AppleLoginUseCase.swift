//
//  AppleLoginUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol AppleLoginUseCase {
    func login(_ token: Data) -> String?
}

public final class AppleLoginUseCaseImpl: AppleLoginUseCase {
    private let appleLoginRepository: AppleLoginRepository

    public init(appleLoginRepository: AppleLoginRepository) {
        self.appleLoginRepository = appleLoginRepository
    }

    public func login(_ token: Data) -> String? {
        return appleLoginRepository.login(token)
    }
}
