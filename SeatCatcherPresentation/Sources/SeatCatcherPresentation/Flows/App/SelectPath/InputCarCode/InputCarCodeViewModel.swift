//
//  InputCarCodeViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/31/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

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

    let departure: Station
    let arrival: Station

    let startJourneyUseCase: StartJourneyUseCase

    let coordinator: Coordinator

    public init(departure: Station, arrival: Station, startJourneyUseCase: StartJourneyUseCase, coordinator: Coordinator) {
        self.departure = departure
        self.arrival = arrival
        self.startJourneyUseCase = startJourneyUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case let .digitChanged(digit, idx):
            state.carCodeDigits[idx] = digit
        case .nextButtonTapped:
            let trainCode = state.carCodeDigits.joined()
            Task {
                let pathHistoryId = try await startJourneyUseCase.execute(
                    departure: departure,
                    arrival: arrival,
                    trainCode: trainCode
                )
                await MainActor.run { coordinator.push(AppScene.selectSeatSection) }
            }
        }
    }
}
