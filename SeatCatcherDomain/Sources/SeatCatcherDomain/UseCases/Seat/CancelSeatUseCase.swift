//
//  CancelSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation

public protocol CancelSeatUseCase {
    func execute(_ seat: Seat) async throws
}

public final class CancelSeatUseCaseImpl: CancelSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(_ seat: Seat) async throws {
        /// 좌석 점유를 해제하고 구독을 취소합니다
        try await seatRepository.cancelSeat()
        try await seatStompRepository.unsubscribeFromSeatOccupied(seat)
    }
}
