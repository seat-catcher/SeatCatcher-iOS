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
        case tagSelected(_ tag: Tag)
        case criterionButtonTapped
        case alertConfirmButtonTapped
        case nextButtonTapped
        case errorOccured(String)
    }

    struct State {
        var nickname: String?
        var currentTag: Tag?
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
    private func saveUserInfo() {
        guard let tag = self.state.currentTag?.rawValue else { return }

        Task { [weak self] in
            guard let self = self else { return }
            do {
                if try await self.userUseCase.saveUserInfo(nickname: "", tag: tag) {
                    userUseCase.setUserInfoRequiredStatus(false)
                } else {
                    self.state.errorMessage = "유저 정보 저장에 실패했습니다."
                }
            } catch {
                self.action(.errorOccured(error.localizedDescription))
            }
        }
    }
}
