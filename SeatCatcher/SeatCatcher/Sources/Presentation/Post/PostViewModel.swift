//
//  PostViewModel.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

@Observable
final class PostViewModel: ViewModel {
    enum Action {
        case onFetchButtonTapped
        case onResetButtonTapped
    }

    enum State {
        case idle
        case loading
        case loaded(Post)
        case error(String)
    }

    private(set) var state = State.idle
    private let postUseCase: PostUseCase

    init(postUseCase: PostUseCase) {
        self.postUseCase = postUseCase
    }

    func action(_ action: Action) {
        switch action {
        case .onFetchButtonTapped:
            Task {
                await MainActor.run { state = .loading }
                do {
                    let post = try await postUseCase.fetchPost(byID: 1)
                    await MainActor.run { state = .loaded(post) }
                } catch {
                    await MainActor.run { state = .error(error.localizedDescription) }
                }
            }
        case .onResetButtonTapped:
            state = .idle
        }
    }
}
