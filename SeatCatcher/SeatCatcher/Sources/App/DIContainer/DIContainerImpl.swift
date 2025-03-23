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
    func resolvePostUseCase() -> PostUseCase {
        let postRepository = PostRepositoryImpl()
        let postUseCase = PostUseCaseImpl(repository: postRepository)
        return postUseCase
    }

    func resolveLoginUseCase() -> LoginUseCase {
        let loginRepository = LoginRepositoryImpl()
        let loginUseCase = LoginUseCaseImpl(loginRepository: loginRepository)
        return loginUseCase
    }

    func resolveTokenUseCase() -> TokenUseCase {
        let tokenRepository = TokenRepositoryImpl()
        let tokenUseCase = TokenUseCaseImpl(tokenRepository: tokenRepository)
        return tokenUseCase
    }
}
