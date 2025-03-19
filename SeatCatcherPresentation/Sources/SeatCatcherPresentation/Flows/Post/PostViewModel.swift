//
//  PostViewModel.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation
import SeatCatcherDomain
import SeatCatcherCore

@Observable
public final class PostViewModel: ViewModel {
    enum Action {
        case onFetchButtonTapped
        case onResetButtonTapped
        case onSheetButtonTapped
        case onNextButtonTapped
    }

    struct State {
        var isLoading = false
        var title: String?
        var content: String?
        var errorMessage: String?
    }

    private(set) var state = State()
    private let postUseCase: PostUseCase
    private let coordinator: Coordinator

    public init(
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
                await MainActor.run { state.isLoading = true }
                do {
                    let post = try await postUseCase.fetchPost(byID: 1)
                    await MainActor.run {
                        state.isLoading = false
                        state.title = post.title
                        state.content = post.content
                    }
                } catch {
                    await MainActor.run {
                        state.isLoading = false
                        state.errorMessage = error.localizedDescription
                    }
                }
            }
        case .onResetButtonTapped:
            state.title = nil
            state.title = nil
        case .onSheetButtonTapped:
            let post = AppSheet.post
            coordinator.presentSheet(post)
        case .onNextButtonTapped:
            let login = AppScene.login
            coordinator.push(login)
        }
    }
}
