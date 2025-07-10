//
//  SelectTagViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/29/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class UserInfoViewModel: ViewModel {
    struct State {
        let store: AppStore

        var tags = [UserTag]()
        var errorMessage: String?
        var isAlertPresented = false
    }

    enum Action {
        case viewAppeared
        case tagSelected(_ tag: UserTag)
        case criterionButtonTapped
        case alertConfirmButtonTapped
        case nextButtonTapped
        case errorOccured(String)
    }

    private(set) var state: State

    let store: AppStore
    private let getRandomNicknameUseCase: GetRandomNicknameUseCase
    private let getRandomUserImageUseCase: GetRandomUserImageUseCase
    private let patchUserInfoUseCase: PatchUserInfoUseCase
    let coordinator: Coordinator

    public init(
        store: AppStore,
        getRandomNicknameuseCase: GetRandomNicknameUseCase,
        getRandomUserImageUseCase: GetRandomUserImageUseCase,
        patchUserInfoUseCase: PatchUserInfoUseCase,
        coordinator: Coordinator
    ) {
        self.store = store
        self.getRandomNicknameUseCase = getRandomNicknameuseCase
        self.getRandomUserImageUseCase = getRandomUserImageUseCase
        self.patchUserInfoUseCase = patchUserInfoUseCase
        self.coordinator = coordinator

        self.state = .init(store: store)
    }

    func action(_ action: Action) {
        switch action {
        case .viewAppeared:
            self.store.user.name = getRandomNicknameUseCase.execute()
            self.store.user.profileImage = getRandomUserImageUseCase.execute()
        case let .tagSelected(tag):
            handleTagSelection(tag)
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

    private func handleTagSelection(_ tag: UserTag) {
        if tag == .none {
            if self.state.tags.contains(.none) {
                self.state.tags.removeAll()
            } else {
                self.state.tags.removeAll()
                self.state.tags.append(.none)
            }
        } else {
            if self.state.tags.contains(tag) {
                self.state.tags.removeAll { $0 == tag }
            } else {
                self.state.tags.removeAll { $0 == .none }
                self.state.tags.append(tag)
            }
        }
    }

    private func saveUserInfo() {
        Task { [patchUserInfoUseCase] in
            do {
                // 1. state -> store 선택된 태그 이전
                store.user.tags = state.tags
                // 2. 새로운 인스턴스를 복사하여 hasOnBoarded를 true로 설정하고 patch
                /// AppStore의 hasOnBoarded 값을 true로 바꾸면 즉시 플로우가 전환되기 때문에 인스턴스 복사 후 설정합니다.
                var requestUser = store.user
                requestUser.hasOnBoarded = true
                let user = try await patchUserInfoUseCase.execute(requestUser)
                coordinator.push(OnboardingScene.userGreeting(user))
            } catch {
                self.action(.errorOccured(error.localizedDescription))
            }
        }
    }
}
