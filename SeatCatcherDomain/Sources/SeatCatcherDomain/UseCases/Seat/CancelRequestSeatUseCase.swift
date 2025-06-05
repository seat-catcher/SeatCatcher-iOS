//
//  CancelRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석요청자 - 좌석 요청 취소 시 호출
public protocol CancelRequestSeatUseCase {
    func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws
}

public final class CancelRequestSeatUseCaseImpl: CancelRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws {
        /// 좌석 요청을 취소합니다
        try await seatRepository.cancelRequestSeat(seat, creditAmount: creditAmount)
        /// 좌석 요청에 대한 응답 구독을 취소합니다
        seatStompRepository.unsubscribeFromSeatRequest(seat, requesterId: requesterId)
    }
}
