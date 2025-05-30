//
//  InputCarCodeGuidingViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/27/25.
//

import Foundation
import SeatCatcherCore

@Observable
public final class InputCarCodeGuidingViewModel: ViewModel {
    struct State {}
    enum Action {
        case nextButtonTapped
    }

    private(set) var state = State()

    let trainCode: String

    let coordinator: Coordinator

    public init(trainCode: String, coordinator: Coordinator) {
        self.trainCode = trainCode
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .nextButtonTapped:
            // TODO: - Code 입력 뷰 연결
            dump(#function)
        }
    }
}
