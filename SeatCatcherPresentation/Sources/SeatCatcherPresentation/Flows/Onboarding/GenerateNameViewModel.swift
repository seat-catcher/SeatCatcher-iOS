//
//  GenerateNameViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/28/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class GenerateNameViewModel: ViewModel {
    enum Action {
        case regenerateButtonTapped
        case nextButtonTapped
    }

    struct State {
        var nickname = "친절한 짐꾼"
        var errorMessage: String?
    }

    private(set) var state = State()

    let coordinator: Coordinator
    private let userUseCase: UserUseCase

    public init(
        userUseCase: UserUseCase,
        coordinator: Coordinator
    ) {
        self.userUseCase = userUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .regenerateButtonTapped:
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    let nickname = try await self.userUseCase.getRandomNickname()
                    await MainActor.run { self.state.nickname = nickname }
                } catch {
                    await MainActor.run { self.state.errorMessage = error.localizedDescription }
                }
            }
        case .nextButtonTapped:
            coordinator.push(OnboardingScene.selectTag(state.nickname))
        }
    }
}
