//
//  OnboardingViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/27/25.
//

import Foundation
import SeatCatcherCore

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

    let coordinator: Coordinator

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .skipButtonTapped:
            coordinator.setOnboardingRequiredStatus(false)
            coordinator.push(OnboardingScene.generateName)
        case .nextButtonTapped:
            coordinator.setOnboardingRequiredStatus(false)
            coordinator.push(OnboardingScene.generateName)
        }
    }

}
