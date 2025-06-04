//
//  AcceptRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 요청 수락 시 호출
public protocol AcceptRequestSeatUseCase {
    func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws
}

public final class AcceptRequestSeatUseCaseImpl: AcceptRequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws {
        /// 좌석 요청을 수락합니다
        try await seatRepository.acceptRequestSeat(seat, requesterId: requesterId)
        /// 좌석 요청자를 점유자로 좌석 상태를 업데이트합니다
        try await seatRepository.changeSeatOccupant(seat, creditAmount: creditAmount)
        /// 좌석 요청을 수신하는 STOMP 구독을 취소합니다
        try await seatStompRepository.unsubscribeFromSeatOccupied(seat)
    }
}
