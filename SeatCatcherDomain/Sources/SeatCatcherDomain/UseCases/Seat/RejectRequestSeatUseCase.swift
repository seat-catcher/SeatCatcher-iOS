//
//  RejectRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 요청 거절 시 호출
public protocol RejectRequestSeatUseCase {
    func execute(_ seat: Seat, requester: SeatRequester) async throws
}

public final class RejectRequestSeatUseCaseImpl: RejectRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(_ seat: Seat, requester: SeatRequester) async throws {
        if let creditAmount = requester.creditAmount {
            try await seatRepository.rejectRequestSeat(seat, requesterId: requester.requesterId, creditAmount: creditAmount)
        }
    }
}
