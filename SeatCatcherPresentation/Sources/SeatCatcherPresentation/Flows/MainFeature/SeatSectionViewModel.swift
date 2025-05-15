//
//  SeatSectionViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/17/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class SeatSectionViewModel: ViewModel {
    
    private let getSeatInSectionUseCase: GetSeatInSectionUseCase
    private let unlockSeatUseCase: UnlockSeatUseCase
    
    enum Action {
        case willAppear
        case willSelectSeat(Seat)
        case willUnlockAllSeats
    }
    
    struct State {
        var selectedSeat: Seat?
        var topSeats: [Seat]
        var bottomSeats: [Seat]
    }
    
    private let userStore: UserStore
    
    public init(
        userStore: UserStore,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase
    ) {
        self.userStore = userStore
        self.getSeatInSectionUseCase = getSeatInSectionUseCase
        self.unlockSeatUseCase = unlockSeatUseCase
    }
    
    private(set) var state = State(topSeats: [], bottomSeats: [])
    
    func action(_ action: Action) {
        switch action {
        // MARK: 좌석 정보 불러오기
        case .willAppear:
            let seats = self.getSeatInSectionUseCase.execute()
            self.state = State(topSeats: seats.top, bottomSeats: seats.bottom)
        // MARK: 좌석 선택
        case .willSelectSeat(let seat):
            // 동일 좌석 재탭: 선택 해제
            if state.selectedSeat?.id == seat.id {
                state.selectedSeat = nil
            } else {
                // 새 좌석 선택
                state.selectedSeat = seat
            }
        // MARK: 좌석 잠금 해제
        case .willUnlockAllSeats:
            state.topSeats = state.topSeats.map { unlockSeatUseCase.execute($0) }
            state.bottomSeats = state.bottomSeats.map { unlockSeatUseCase.execute($0) }
        }
    }
}
