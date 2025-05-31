//
//  InputCarCodeViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/31/25.
//

import Foundation
import SeatCatcherCore

@Observable
public final class InputCarCodeViewModel: ViewModel {
    struct State {
        var carCodeDigits: [String] = ["", "", "", ""]
    }
    enum Action {
        case digitChanged(String, Int)
        case nextButtonTapped
    }
    
    private(set) var state = State()
    let coordinator: Coordinator

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case let .digitChanged(digit, idx):
            state.carCodeDigits[idx] = digit
        case .nextButtonTapped:
            dump(#function)
        }
    }
}
