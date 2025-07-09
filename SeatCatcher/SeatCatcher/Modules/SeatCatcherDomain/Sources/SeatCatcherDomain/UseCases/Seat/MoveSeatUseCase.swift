//
//  MoveSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation
import Combine

public protocol MoveSeatUseCase {
    @MainActor func execute(from oldSeat: Seat, to newSeat: Seat, creditAmount: Int) async throws  -> AnyPublisher<SeatRequester, Error>
}

public final class MoveSeatUseCaseImpl: MoveSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    @MainActor
    public func execute(from oldSeat: Seat, to newSeat: Seat, creditAmount: Int) async throws -> AnyPublisher<SeatRequester, Error> {
        /// 기존 좌석 정보를 삭제합니다
        try await seatRepository.cancelSeat()
        /// 기존 앉은 좌석에 대한 요청 구독을 해제합니다
        seatStompRepository.unsubscribeFromSeatOccupied(oldSeat)
        /// 이후 새로운 좌석 정보를 등록합니다
        try await seatRepository.registerSeat(newSeat, creditAmount: creditAmount)
        /// 앉은 좌석에 대한 요청 구독을 시작합니다
        seatStompRepository.subscribeToSeatOccupied(newSeat)
        /// 해당 퍼블리셔를 리턴합니다
        return seatStompRepository.getSeatRequesterPublisher()
    }
}
