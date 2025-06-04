//
//  RejectRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 요청 거절 시 호출
public protocol RejectRequestSeatUseCase {
    func execute(seat: Seat, requesterId: Int, creditAmount: Int)
}

final class RejectRequestSeatUseCaseImpl: RejectRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    func execute(seat: Seat, requesterId: Int, creditAmount: Int) {
        try await seatRepository.rejectRequestSeat(seatId: seat.id, requesterId: requesterId, creditAmount: creditAmount)
    }
}
