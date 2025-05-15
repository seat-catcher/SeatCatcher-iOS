//
//  SeatSectionViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/17/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@MainActor
@Observable
public final class SeatSectionViewModel: ViewModel {
    
    public enum Action {
        case willAppear
        case willSelectSeat(Seat)
        case willUnlockAllSeats
    }
    
    public struct State {
        var selectedSeat: Seat?
        var topSeats: [Seat]
        var bottomSeats: [Seat]
    }
    
    private let model: SeatSectionModel
    private let userStore: UserStore
    private(set) var state: State
    
    init(
        userStore: UserStore,
        model: SeatSectionModel
    ) {
        self.userStore = userStore
        self.model = model
        self.state = State(topSeats: [], bottomSeats: [])
    }
    
    public func action(_ action: Action) {
        switch action {
        case .willAppear:
            Task {
                do {
                    let seatSection = try await model.fetchSeats()
                    state = State(
                        selectedSeat: state.selectedSeat,
                        topSeats: seatSection.topSeats,
                        bottomSeats: seatSection.bottomSeats
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
        case .willSelectSeat(let seat):
            if state.selectedSeat?.id == seat.id {
                state.selectedSeat = nil
            } else {
                state.selectedSeat = seat
            }
            
        case .willUnlockAllSeats:
            let seatSection = model.unlockAllSeats(
                topSeats: state.topSeats,
                bottomSeats: state.bottomSeats
            )
            state = State(
                selectedSeat: state.selectedSeat,
                topSeats: seatSection.topSeats,
                bottomSeats: seatSection.bottomSeats
            )
        }
    }
}
