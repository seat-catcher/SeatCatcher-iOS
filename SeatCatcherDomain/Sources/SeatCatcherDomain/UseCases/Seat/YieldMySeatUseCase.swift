//
//  YieldMySeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 교환 성공 시 호출
public protocol YieldMySeatUseCase {
    func execute(_ seat: Seat, requester: SeatRequester)
}

public final class YieldMySeatUseCaseImpl: YieldMySeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(_ seat: Seat, requester: SeatRequester) {
        /// 좌석 요청을 수신하는 STOMP 구독을 취소합니다
        seatStompRepository.unsubscribeFromSeatRequest(seat, requesterId: requester.requesterId)
    }
}
