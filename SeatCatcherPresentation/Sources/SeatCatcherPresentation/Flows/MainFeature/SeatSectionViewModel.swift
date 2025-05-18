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
        var isBlocked: Bool
        var topSeats: [Seat]
        var bottomSeats: [Seat]
    }
    
    struct SeatSection: Sendable {
        var topSeats: [Seat]
        var bottomSeats: [Seat]
    }
    
    private let appStore: AppStore
    private let getSeatInSectionUseCase: GetSeatInSectionUseCase
    private let unlockSeatUseCase: UnlockSeatUseCase
    private(set) var state: State
    
    public init(
        appStore: AppStore,
        isBlocked: Bool,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase
    ) {
        self.appStore = appStore
        self.getSeatInSectionUseCase = getSeatInSectionUseCase
        self.unlockSeatUseCase = unlockSeatUseCase
        self.state = State(isBlocked: isBlocked, topSeats: [], bottomSeats: [])
    }
    
    public func action(_ action: Action) {
        switch action {
        case .willAppear:
            Task {
                do {
                    /// 좌석 정보를 불러옵니다
                    let seatSection = try await fetchSeats()
                    state.topSeats = seatSection.topSeats
                    state.bottomSeats = seatSection.bottomSeats
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
            Task {
                do {
                    /// 크레딧 관련 테스크 처리를 위한 유즈케이스
                    try await unlockSeatUseCase.execute()
                    // TODO: 전역 잠금 해제 상태 관리
                    /// 잠금 해제는 로컬에서 처리
                    state.isBlocked = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchSeats() async throws -> SeatSection {
        let seats = try await getSeatInSectionUseCase.execute()
        return SeatSection(topSeats: seats.top, bottomSeats: seats.bottom)
    }
}
