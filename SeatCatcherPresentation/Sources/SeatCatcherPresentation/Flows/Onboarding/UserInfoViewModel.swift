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
        case nicknameFetched(_ nickname: String)
        case tagSelected(_ tag: UserTag)
        case criterionButtonTapped
        case alertConfirmButtonTapped
        case nextButtonTapped
        case errorOccured(String)
    }

    struct State {
        var user = User(name: "", profileImage: UserImage.allCases.randomElement()!, tags: [], credit: 0)
        var errorMessage: String?
        var isAlertPresented = false
    }

    private(set) var state = State()

    private let userUseCase: UserUseCase
    let coordinator: Coordinator

    public init(
        userUseCase: UserUseCase,
        coordinator: Coordinator
    ) {
        self.userUseCase = userUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .viewAppeared:
            self.fetchNickname()
        case let .nicknameFetched(nickname):
            self.state.user.name = nickname
        case let .tagSelected(tag):
            if self.state.user.tags.contains(tag) {
                self.state.user.tags.removeAll { $0 == tag }
            } else {
                self.state.user.tags.append(tag)
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
    private func fetchNickname() {
        Task {
            var nickname = "친절한 짐꾼"
            do {
                nickname = try await userUseCase.getRandomNickname()
                action(.nicknameFetched(nickname))
            } catch {
                action(.errorOccured(error.localizedDescription))
            }
        }
    }

    @MainActor
    private func saveUserInfo() {
        let user = self.state.user

        Task {
            do {
                let user = try await self.userUseCase.saveUserInfo(user: user)
                coordinator.push(OnboardingScene.userGreeting(user))
            } catch {
                self.action(.errorOccured(error.localizedDescription))
            }
        }
    }
}
