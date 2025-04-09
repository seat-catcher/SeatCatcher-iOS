//
//  OnboardingViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/27/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class OnboardingViewModel: ViewModel {
    enum Action {
        case skipButtonTapped
        case nextButtonTapped
    }

    struct State {
        var scrollID: Int?
    }

    private(set) var state = State()

    private let userUseCase: UserUseCase
    let coordinator: Coordinator

    public init(userUseCase: UserUseCase, coordinator: Coordinator) {
        self.userUseCase = userUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .skipButtonTapped:
            userUseCase.setOnboardingRequiredStatus(false)
            coordinator.push(OnboardingScene.userInfo)
        case .nextButtonTapped:
            userUseCase.setOnboardingRequiredStatus(false)
            coordinator.push(OnboardingScene.userInfo)
        }
    }

}
