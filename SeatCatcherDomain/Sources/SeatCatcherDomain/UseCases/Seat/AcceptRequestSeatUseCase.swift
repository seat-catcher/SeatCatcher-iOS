//
//  AcceptRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 요청 수락 시 호출
public protocol AcceptRequestSeatUseCase {
    func execute(seat: Seat, requesterId: Int) async throws 
}

public final class AcceptRequestSeatUseCaseImpl: AcceptRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(seat: Seat, requesterId: Int) async throws {
        try await seatRepository.acceptRequestSeat(seatId: seat.id, requesterId: requesterId)
    }
}
