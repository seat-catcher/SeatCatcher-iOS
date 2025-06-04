//
//  ReceiveSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation
import Combine

/// 좌석요청자 - 좌석 교환 성공 시 호출
public protocol ReceiveSeatUseCase {
    func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws -> AnyPublisher<SeatRequester, Error>
}

public final class ReceiveSeatUseCaseImpl: ReceiveSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws -> AnyPublisher<SeatRequester, Error> {
        /// 좌석 요청자를 점유자로 좌석 상태를 업데이트합니다
        try await seatRepository.changeSeatOccupant(seat, creditAmount: creditAmount)
        /// 좌석 요청을 수신하는 STOMP 구독을 취소합니다
        try await seatStompRepository.unsubscribeFromSeatRequest(seat, requesterId: requesterId)
        /// 앉은 좌석에 대한 요청 구독을 시작합니다
        try await seatStompRepository.subscribeToSeatOccupied(seat)
        /// 해당 퍼블리셔를 리턴합니다
        return try await seatStompRepository.getSeatRequesterPublisher()
    }
}
