//
//  SelectLineViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/14/25.
//

import Foundation
import SeatCatcherCore

@Observable
public final class SelectLineViewModel: ViewModel {
    struct State {
        var selection: LineSelectionState?
    }
    enum Action {
        case lineNumber2ButtonTapped
        case lineNumber7ButtonTapped
        case nextButtonTapped
    }

    private(set) var state = State()
    let boardingState: BoardingState

    let coordinator: Coordinator

    public init(boardingState: BoardingState, coordinator: Coordinator) {
        self.boardingState = boardingState
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .lineNumber2ButtonTapped:
            if state.selection == .two { state.selection = nil }
            else { state.selection = .two }
        case .lineNumber7ButtonTapped:
            if state.selection == .seven { state.selection = nil }
            else { state.selection = .seven }
        case .nextButtonTapped:
            coordinator.push(
                AppScene.selectPath(
                    boardingState: boardingState,
                    line: state.selection?.rawValue ?? 2
                )
            )
        }
    }
}

extension SelectLineViewModel {
    enum LineSelectionState: Int {
        case two = 2
        case seven = 7
    }
}
