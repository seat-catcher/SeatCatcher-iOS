//
//  SeatSectionModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/15/25.
//

import Foundation
import SeatCatcherDomain

public final class SeatSectionModel: Sendable {
    private let getSeatInSectionUseCase: GetSeatInSectionUseCase
    private let unlockSeatUseCase: UnlockSeatUseCase
    
    struct SeatSection: Sendable {
        var topSeats: [Seat]
        var bottomSeats: [Seat]
    }
    
    public init(
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase
    ) {
        self.getSeatInSectionUseCase = getSeatInSectionUseCase
        self.unlockSeatUseCase = unlockSeatUseCase
    }
    
    // 네트워크 호출 사용하므로 비동기 처리
    func fetchSeats() async throws -> SeatSection {
        let seats = try await getSeatInSectionUseCase.execute()
        return SeatSection(topSeats: seats.top, bottomSeats: seats.bottom)
    }
    
    // 로컬에서 처리
    func unlockAllSeats(topSeats: [Seat], bottomSeats: [Seat]) -> SeatSection {
        let unlockedTopSeats = topSeats.map { unlockSeatUseCase.execute($0) }
        let unlockedBottomSeats = bottomSeats.map { unlockSeatUseCase.execute($0) }
        return SeatSection(topSeats: unlockedTopSeats, bottomSeats: unlockedBottomSeats)
    }
}
