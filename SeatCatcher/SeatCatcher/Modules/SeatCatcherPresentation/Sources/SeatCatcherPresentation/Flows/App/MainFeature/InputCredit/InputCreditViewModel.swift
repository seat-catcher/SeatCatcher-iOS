//
//  InputCreditViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 7/9/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class InputCreditViewModel: ViewModel {
    struct State {
        let store: AppStore

        var credit = ""
        var creditAmount: Int? { Int(credit) }
        var isCreditExceeded: Bool {
            guard let creditAmount = Int(credit) else { return false }
            return store.user.credit < creditAmount
        }
        var isCreditValid: Bool {
            guard let creditAmount = Int(credit) else { return false }
            return store.user.credit >= creditAmount
        }
        var errorMessage: String?
    }

    enum Action {
        case creditChanged(String)
        case requestButtonDidTap
    }

    private(set) var state: State

    private let stationName: String
    private let seat: Seat
    private let requestSeatUseCase: RequestSeatUseCase
    private let store: AppStore
    let coordinator: Coordinator


    public init(
        stationName: String,
        seat: Seat,
        requestSeatUseCase: RequestSeatUseCase,
        store: AppStore,
        coordinator: Coordinator
    ) {
        self.stationName = stationName
        self.seat = seat
        self.requestSeatUseCase = requestSeatUseCase
        self.store = store
        self.coordinator = coordinator
        self.state = .init(store: store)
    }

    func action(_ action: Action) {
        switch action {
        case let .creditChanged(credit):
            state.credit = credit
        case .requestButtonDidTap:
            guard let creditAmount = Int(state.credit) else { return }
            Task { [requestSeatUseCase] in
                do {
                    let requesteePublisher = try await requestSeatUseCase.execute(
                        seat,
                        requesterId: store.user.id,
                        creditAmount: creditAmount
                    )
                    await MainActor.run {
                        store.subscribeToSeatRequesteePublisher(requesteePublisher, seatId: seat.id)
                        coordinator.push(AppScene.mainFeatureActionComplete(actionCase:
                                .requestInProcess(
                                    stationName: stationName,
                                    seat: seat,
                                    creditAmount: creditAmount
                                )
                        ))
                    }
                } catch {
                    await MainActor.run {
                        self.state.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
