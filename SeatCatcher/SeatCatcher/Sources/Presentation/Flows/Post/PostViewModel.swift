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
        case isSheetButtonTapped
        case isNextButtonTapped
    }

    enum State {
        case idle
        case isLoading
        case isLoaded(Post)
        case isErrorOccurred(String)
    }

    private(set) var state = State.idle
    private let postUseCase: PostUseCase
    private let coordinator: Coordinator

    init(
        postUseCase: PostUseCase,
        coordinator: Coordinator
    ) {
        self.postUseCase = postUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .onFetchButtonTapped:
            Task {
                await MainActor.run { state = .isLoading }
                do {
                    let post = try await postUseCase.fetchPost(byID: 1)
                    await MainActor.run { state = .isLoaded(post) }
                } catch {
                    await MainActor.run { state = .isErrorOccurred(error.localizedDescription) }
                }
            }
        case .onResetButtonTapped:
            state = .idle
        case .isSheetButtonTapped:
            coordinator.presentSheet(.post)
        case .isNextButtonTapped:
            coordinator.push(.next)
        }
    }
}
