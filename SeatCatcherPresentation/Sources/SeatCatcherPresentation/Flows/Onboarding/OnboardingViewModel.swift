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

    let coordinator: Coordinator

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    private(set) var state = State()

    func action(_ action: Action) {
        switch action {
        case .skipButtonTapped:
            dump(#function)
        case .nextButtonTapped:
            dump(#function)
        }
    }

}
