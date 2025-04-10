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
        var nickname: String?
        var currentTag: UserTag?
        var errorMessage: String?
        var isAlertPresented: Bool = false
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
            self.state.nickname = nickname
        case let .tagSelected(tag):
            if self.state.currentTag == tag {
                self.state.currentTag = nil
            } else {
                self.state.currentTag = tag
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
        guard let tag = self.state.currentTag else { return }

        Task { [weak self] in
            guard let self = self else { return }
            do {
                if try await self.userUseCase.saveUserInfo(nickname: "", tag: tag) {
                    coordinator.push(OnboardingScene.userGreeting)
                } else {
                    self.action(.errorOccured("유저 정보 저장에 실패했습니다."))
                }
            } catch {
                self.action(.errorOccured(error.localizedDescription))
            }
        }
    }
}
