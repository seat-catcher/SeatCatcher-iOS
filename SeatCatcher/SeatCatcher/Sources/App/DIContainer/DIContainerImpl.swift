//
//  DIContainerImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import Moya
import SeatCatcherDomain
import SeatCatcherCore
import SeatCatcherData

final class DIContainerImpl: DIContainer {
    private let appStore = AppStore(user: User())

    private lazy var loginRepository = LoginRepositoryImpl()
    private lazy var tokenRepository = TokenRepositoryImpl()
    private lazy var userRepository = UserRepositoryImpl()

    private lazy var authUseCase = AuthUseCaseImpl(
        loginRepository: loginRepository,
        tokenRepository: tokenRepository,
        userRepository: userRepository
    )

    private lazy var userUseCase = UserUseCaseImpl(
        userRepository: userRepository
    )

    func resolveAuthUseCase() -> AuthUseCase {
        return authUseCase
    }

    func resolveUserUseCase() -> UserUseCase {
        return userUseCase
    }

    func resolveAppStore() -> AppStore {
        return appStore
    }
}
