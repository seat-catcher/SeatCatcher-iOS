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
    let incoming: Incoming

    private let store: AppStore

    private let startJourneyUseCase: StartJourneyUseCase
    private let subscribeArrivalTimeUseCase: SubscribeArrivalTimeUseCase

    let coordinator: Coordinator

    public init(
        departure: Station,
        arrival: Station,
        incoming: Incoming,
        store: AppStore,
        startJourneyUseCase: StartJourneyUseCase,
        subscribeArrivalTimeUseCase: SubscribeArrivalTimeUseCase,
        coordinator: Coordinator
    ) {
        self.departure = departure
        self.arrival = arrival
        self.incoming = incoming
        self.store = store
        self.startJourneyUseCase = startJourneyUseCase
        self.subscribeArrivalTimeUseCase = subscribeArrivalTimeUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case let .digitChanged(digit, idx):
            state.carCodeDigits[idx] = digit
        case .nextButtonTapped:
            let carCode = state.carCodeDigits.joined()
            Task { [startJourneyUseCase] in
                let (pathHistoryId, expectedArrivalTime) = try await startJourneyUseCase.execute(
                    departure: departure,
                    arrival: arrival,
                    trainCode: incoming.trainCode
                )
                let arrivalTimePublisher = subscribeArrivalTimeUseCase.execute(pathHistoryId: pathHistoryId)

                await MainActor.run {
                    store.startJourney(
                        carCode: carCode,
                        incoming: incoming,
                        departure: departure,
                        arrival: arrival,
                        expectedArrivalTime: expectedArrivalTime,
                        arrivalTimePublisher: arrivalTimePublisher
                    )
                    coordinator.popToRoot()
                    coordinator.push(AppScene.selectSeatSection)
                }
            }
        }
    }
}
