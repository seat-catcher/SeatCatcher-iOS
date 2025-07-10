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
        let appStore: AppStore

        var credit = ""
        var creditAmount: Int? { Int(credit) }
        var isCreditExceeded: Bool {
            guard let creditAmount = Int(credit) else { return false }
            return appStore.user.credit < creditAmount
        }
        var isCreditValid: Bool {
            guard let creditAmount = Int(credit) else { return false }
            return appStore.user.credit >= creditAmount
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
    private let appStore: AppStore
    let coordinator: Coordinator


    public init(
        stationName: String,
        seat: Seat,
        requestSeatUseCase: RequestSeatUseCase,
        appStore: AppStore,
        coordinator: Coordinator
    ) {
        self.stationName = stationName
        self.seat = seat
        self.requestSeatUseCase = requestSeatUseCase
        self.appStore = appStore
        self.coordinator = coordinator
        self.state = .init(appStore: appStore)
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
                        requesterId: appStore.user.id,
                        creditAmount: creditAmount
                    )
                    await MainActor.run {
                        appStore.subscribeToSeatRequesteePublisher(requesteePublisher, seatId: seat.id)
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
