//
//  DIContainerImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import Moya

@Observable
final class DIContainerImpl: DIContainer {
    func resolvePostUseCase() -> PostUseCase {
        let provider = MoyaProvider<PostAPI>()
        let postRepository = PostRepositoryImpl(provider: provider)
        let postUseCase = PostUseCaseImpl(repository: postRepository)
        return postUseCase
    }
}
