//
//  SelectBoardingStateViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/25/25.
//

import Foundation
import SeatCatcherCore

@Observable
public final class SelectBoardingStateViewModel: ViewModel {
    struct State {
        var boardingState: BoardingState?
    }

    enum Action {
        case hasBoardButtonTapped
        case hasNotBoardedButtonTapped
        case nextButtonTapped
    }

    private(set) var state = State()

    let coordinator: Coordinator

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .hasBoardButtonTapped:
            self.state.boardingState = .boarded
        case .hasNotBoardedButtonTapped:
            self.state.boardingState = .notBoarded
        case .nextButtonTapped:
            guard let boardingState = self.state.boardingState else { return }
            self.coordinator.push(AppScene.selectLine(boardingState: boardingState))
        }
    }

}
