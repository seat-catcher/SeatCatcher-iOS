//
//  GenerateNameViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/28/25.
//

import Foundation
import SeatCatcherCore

@Observable
public final class GenerateNameViewModel: ViewModel {
    enum Action {
        case regenerateButtonTapped
        case nextButtonTapped
    }

    struct State {
        var nickname = "친절한 짐꾼"
    }

    let coordinator: Coordinator

    private(set) var state = State()

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .regenerateButtonTapped:
            print(#function)
        case .nextButtonTapped:
            print(#function)
        }
    }
}
