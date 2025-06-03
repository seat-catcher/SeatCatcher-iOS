//
//  InputCarCodeGuidingViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/27/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class InputCarCodeGuidingViewModel: ViewModel {
    struct State {}
    enum Action {
        case nextButtonTapped
    }

    private(set) var state = State()

    let departure: Station
    let arrival: Station
    let incoming: Incoming
    let coordinator: Coordinator

    public init(departure: Station, arrival: Station, incoming: Incoming, coordinator: Coordinator) {
        self.departure = departure
        self.arrival = arrival
        self.incoming = incoming
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .nextButtonTapped:
            coordinator.push(
                AppScene.inputCarCode(
                    departure: departure,
                    arrival: arrival,
                    incoming: incoming
                )
            )
        }
    }
}
