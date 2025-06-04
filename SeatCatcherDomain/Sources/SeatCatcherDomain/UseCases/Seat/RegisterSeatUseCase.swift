//
//  RegisterSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation

public protocol RegisterSeatUseCase {
    func execute(_ seat: Seat) async throws
}

public final class RegisterSeatUseCaseImpl: RegisterSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(_ seat: Seat) async throws {
        /// 좌석 점유 상태를 업데이트합니다
        try await seatRepository.registerSeat(seat)
        /// 좌석 요청 수신에 대한 구독을 시작합니다
        try await seatStompRepository.subscribeToSeatOccupied(seat)
    }
}
