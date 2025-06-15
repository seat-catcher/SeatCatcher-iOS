//
//  RegisterSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation
import Combine

public protocol RegisterSeatUseCase {
    @MainActor func execute(_ seat: Seat, creditAmount: Int) async throws -> AnyPublisher<SeatRequester, Error>
}

public final class RegisterSeatUseCaseImpl: RegisterSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    @MainActor
    public func execute(_ seat: Seat, creditAmount: Int) async throws -> AnyPublisher<SeatRequester, Error> {
        /// 좌석 점유 상태를 업데이트합니다
        try await seatRepository.registerSeat(seat, creditAmount: creditAmount)
        /// 좌석 요청 수신에 대한 구독을 시작합니다
        seatStompRepository.subscribeToSeatOccupied(seat)
        /// 해당 퍼블리셔를 리턴합니다
        return seatStompRepository.getSeatRequesterPublisher()
    }
}
