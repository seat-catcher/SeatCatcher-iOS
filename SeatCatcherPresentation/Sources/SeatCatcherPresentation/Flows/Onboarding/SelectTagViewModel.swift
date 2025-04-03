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
public final class SelectTagViewModel: ViewModel {
    enum Action {
        case tagSelected(_ tag: UserTag)
        case nextButtonTapped
        case errorOccured(String)
    }

    struct State {
        var currentTag: UserTag?
        var errorMessage: String?
    }

    private(set) var state = State()

    let nickname: String

    private let userUseCase: UserUseCase
    let coordinator: Coordinator

    public init(
        nickname: String,
        userUseCase: UserUseCase,
        coordinator: Coordinator
    ) {
        self.nickname = nickname
        self.userUseCase = userUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case let .tagSelected(tag):
            self.state.currentTag = tag
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
                if try await self.userUseCase.saveUserInfo(nickname: self.nickname, tag: tag) {
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
