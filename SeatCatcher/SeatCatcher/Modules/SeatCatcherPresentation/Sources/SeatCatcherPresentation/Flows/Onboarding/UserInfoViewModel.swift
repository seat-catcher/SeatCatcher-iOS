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

    let appStore: AppStore
    private let getRandomNicknameUseCase: GetRandomNicknameUseCase
    private let getRandomUserImageUseCase: GetRandomUserImageUseCase
    private let patchUserInfoUseCase: PatchUserInfoUseCase
    let coordinator: Coordinator

    public init(
        appStore: AppStore,
        getRandomNicknameuseCase: GetRandomNicknameUseCase,
        getRandomUserImageUseCase: GetRandomUserImageUseCase,
        patchUserInfoUseCase: PatchUserInfoUseCase,
        coordinator: Coordinator
    ) {
        self.appStore = appStore
        self.getRandomNicknameUseCase = getRandomNicknameuseCase
        self.getRandomUserImageUseCase = getRandomUserImageUseCase
        self.patchUserInfoUseCase = patchUserInfoUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .viewAppeared:
            self.appStore.user.name = getRandomNicknameUseCase.execute()
            self.appStore.user.profileImage = getRandomUserImageUseCase.execute()
        case let .tagSelected(tag):
            if tag == .none {
                if self.appStore.user.tags.contains(.none) {
                    self.appStore.user.tags.removeAll()
                } else {
                    self.appStore.user.tags.removeAll()
                    self.appStore.user.tags.append(.none)
                }
            } else {
                if self.appStore.user.tags.contains(tag) {
                    self.appStore.user.tags.removeAll { $0 == tag }
                } else {
                    self.appStore.user.tags.removeAll { $0 == .none }
                    self.appStore.user.tags.append(tag)
                }
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
                // AppStore의 User hasOnBoarded 값을 true로 바꾸면 즉시 플로우가 전환되므로,
                // 새로운 인스턴스를 복사하여 hasOnBoarded에 true 대입 후 UseCase에 넘깁니다.
                var requestUser = appStore.user
                requestUser.hasOnBoarded = true
                let user = try await patchUserInfoUseCase.execute(requestUser)
                coordinator.push(OnboardingScene.userGreeting(user))
            } catch {
                self.action(.errorOccured(error.localizedDescription))
            }
        }
    }
}
