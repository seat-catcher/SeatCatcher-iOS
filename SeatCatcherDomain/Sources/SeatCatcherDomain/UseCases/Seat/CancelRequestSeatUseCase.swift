//
//  CancelRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석요청자 - 좌석 요청 취소 시 호출
public protocol CancelRequestSeatUseCase {
    func execute(seat: Seat, creditAmount: Int) async throws
}

public final class CancelRequestSeatUseCaseImpl: CancelRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(seat: Seat, creditAmount: Int) async throws {
        try await seatRepository.cancelRequestSeat(seatId: seat.id, creditAmount: creditAmount)
    }
}
