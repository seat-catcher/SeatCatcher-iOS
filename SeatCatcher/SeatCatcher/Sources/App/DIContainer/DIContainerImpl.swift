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

@Observable
final class DIContainerImpl: DIContainer {
    func resolveAuthUseCase() -> AuthUseCase {
        let loginRepository = LoginRepositoryImpl()
        let tokenRepository = TokenRepositoryImpl()
        let userRepository = UserRepositoryImpl()

        let authUseCase = AuthUseCaseImpl(
            loginRepository: loginRepository,
            tokenRepository: tokenRepository,
            userRepository: userRepository
        )
        
        return authUseCase
    }

    func resolveUserUseCase() -> UserUseCase {
        let userRepository = UserRepositoryImpl()
        let userUseCase = UserUseCaseImpl(userRepository: userRepository)
        return userUseCase
    }
}
