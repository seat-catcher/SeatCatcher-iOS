//
//  SelectTrainViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/27/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class SelectTrainViewModel: ViewModel {
    struct State {
        var incomings: [Incoming] = []
        var errorMessage: String?
        var selectedIncoming: Incoming?
    }
    enum Action {
        case viewWillAppear
        case pulledToRefresh
        case incomingSelected(Incoming)
        case nextButtonTapped
    }

    let departure: Station
    let arrival: Station
    let boardingState: BoardingState

    private(set) var state = State()

    private let getIncomingsUseCase: GetIncomingsUseCase

    let coordinator: Coordinator

    public init(
        departure: Station,
        arrival: Station,
        boardingState: BoardingState,
        getIncomingsUseCase: GetIncomingsUseCase,
        coordinator: Coordinator
    ) {
        self.departure = departure
        self.arrival = arrival
        self.boardingState = boardingState
        self.getIncomingsUseCase = getIncomingsUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    let incomings = try await getIncomingsUseCase.execute(departure: departure, arrival: arrival)
                    state.incomings = incomings
                } catch {
                    dump(error.localizedDescription)
                    state.errorMessage = error.localizedDescription
                }
            }
        case .pulledToRefresh:
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    let incomings = try await getIncomingsUseCase.execute(departure: departure, arrival: arrival)
                    state.incomings = incomings
                } catch {
                    dump(error.localizedDescription)
                    state.errorMessage = error.localizedDescription
                }
            }
        case .incomingSelected(let incoming):
            if self.state.selectedIncoming == incoming { self.state.selectedIncoming = nil }
            else { self.state.selectedIncoming = incoming }
        case .nextButtonTapped:
            // TODO: - TrainCode 입력 뷰 연결
            dump(#function)
        }
    }
}
