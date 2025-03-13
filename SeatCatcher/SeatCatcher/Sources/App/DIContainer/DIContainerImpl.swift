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
    private let coordinator: Coordinator

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func injectPostViewModel() -> PostViewModel {
        let provider = MoyaProvider<PostAPI>()
        let postRepository = PostRepositoryImpl(provider: provider)
        let postUseCase = PostUseCaseImpl(repository: postRepository)
        return PostViewModel(
            postUseCase: postUseCase,
            coordinator: coordinator
        )
    }
}
