//
//  RequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation
import Combine

/// 좌석요청자 - 좌석 요청 시 호출
public protocol RequestSeatUseCase {
    @MainActor func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws -> AnyPublisher<SeatRequestee, Error>
}

public final class RequestSeatUseCaseImpl: RequestSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws -> AnyPublisher<SeatRequestee, Error> {
        /// 좌석 요청을 송신합니다
        try await seatRepository.postRequestSeat(seat, creditAmount: creditAmount)
        /// 좌석 요청에 대한 응답을 구독합니다
        try await seatStompRepository.subscribeToSeatRequest(seat, requesterId: requesterId)
        /// 해당 퍼블리셔를 리턴합니다
        return try await seatStompRepository.getSeatRequesteePublisher()
    }
}
