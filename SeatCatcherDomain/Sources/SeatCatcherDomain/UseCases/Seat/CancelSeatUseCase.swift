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
        /// 좌석 점유를 해제합니다
        try await seatRepository.cancelSeat()
        /// 좌석 요청에 대한 구독을 취소합니다
        seatStompRepository.unsubscribeFromSeatOccupied(seat)
    }
}
