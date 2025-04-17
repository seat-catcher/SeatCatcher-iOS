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

/// 전역 의존성 주입 도구입니다.
final class DIContainerImpl {
    // MARK: - Store Instances
    private let appStore = AppStore(user: User())

    // MARK: - Repository Instances
    private lazy var loginRepository = LoginRepositoryImpl()
    private lazy var tokenRepository = TokenRepositoryImpl()
    private lazy var userRepository = UserRepositoryImpl()

    // MARK: - UseCase Instances
    private lazy var authUseCase = AuthUseCaseImpl(
        loginRepository: loginRepository,
        tokenRepository: tokenRepository,
        userRepository: userRepository
    )
    private lazy var userUseCase = UserUseCaseImpl(
        userRepository: userRepository
    )
}

/// DIContainer 프로토콜 Resolve 메소드들의 구현입니다.
extension DIContainerImpl: DIContainer {
    // MARK: - UseCase Resolvers
    func resolveAuthUseCase() -> AuthUseCase { return authUseCase }
    func resolveUserUseCase() -> UserUseCase { return userUseCase }

    // MARK: - Store Resolvers
    func resolveAppStore() -> AppStore { return appStore }
}
