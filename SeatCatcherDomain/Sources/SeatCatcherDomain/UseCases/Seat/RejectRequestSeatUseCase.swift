//
//  RejectRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 요청 거절 시 호출
public protocol RejectRequestSeatUseCase {
    func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws
}

public final class RejectRequestSeatUseCaseImpl: RejectRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws {
        try await seatRepository.rejectRequestSeat(seat, requesterId: requesterId, creditAmount: creditAmount)
    }
}
