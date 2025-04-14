//
//  SelectTagViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/29/25.
//

import Foundation
import SeatCatcherDomain
import SeatCatcherCore

@Observable
public final class UserInfoViewModel: ViewModel {
    enum Action {
        case viewAppeared
        case tagSelected(_ tag: UserTag)
        case criterionButtonTapped
        case alertConfirmButtonTapped
        case nextButtonTapped
        case errorOccured(String)
    }

    struct State {
        var errorMessage: String?
        var isAlertPresented = false
    }

    private(set) var state = State()

    private let userUseCase: UserUseCase
    private let userStore: UserStore
    let coordinator: Coordinator

    public init(
        userStore: UserStore,
        userUseCase: UserUseCase,
        coordinator: Coordinator
    ) {
        self.userStore = userStore
        self.userUseCase = userUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .viewAppeared:
            self.userStore.user.name = userUseCase.getRandomNickname()
            self.userStore.user.profileImage = userUseCase.getRandomUserImage()
        case let .tagSelected(tag):
            if self.userStore.user.tags.contains(tag) {
                self.userStore.user.tags.removeAll { $0 == tag }
            } else {
                self.userStore.user.tags.append(tag)
            }
        case .criterionButtonTapped:
            self.state.isAlertPresented = true
        case .alertConfirmButtonTapped:
            self.state.isAlertPresented = false
        case .nextButtonTapped:
            saveUserInfo()
        case let .errorOccured(description):
            self.state.errorMessage = description
        }
    }

    @MainActor
    private func saveUserInfo() {
        Task {
            do {
                let user = try await self.userUseCase.saveUserInfo(user: userStore.user)
                userStore.user = user
                coordinator.push(OnboardingScene.userGreeting)
            } catch {
                self.action(.errorOccured(error.localizedDescription))
            }
        }
    }
}
