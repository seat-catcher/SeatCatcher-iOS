//
//  AcceptRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 요청 수락 시 호출
public protocol AcceptRequestSeatUseCase {
    func execute(seat: Seat, requesterId: Int, creditAmount: Int) async throws
}

public final class AcceptRequestSeatUseCaseImpl: AcceptRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(seat: Seat, requesterId: Int, creditAmount: Int) async throws {
        try await seatRepository.acceptRequestSeat(seatId: seat.id, requesterId: requesterId) // 요청 수락
        try await seatRepository.changeSeatOccupant(seatId: seat.id, creditAmount: creditAmount) // 좌석 교환
    }
}
