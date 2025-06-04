//
//  MoveSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation

public protocol MoveSeatUseCase {
    func execute(from oldSeat: Seat, to newSeat: Seat) async throws
}

public final class MoveSeatUseCaseImpl: MoveSeatUseCase {
    
    private let seatRepository: SeatRepository
    private let seatStompRepository: SeatStompRepository
    
    public init(seatRepository: SeatRepository, seatStompRepository: SeatStompRepository) {
        self.seatRepository = seatRepository
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(from oldSeat: Seat, to newSeat: Seat) async throws {
        /// 기존 좌석 정보를 삭제합니다
        try await seatRepository.cancelSeat()
        try await seatStompRepository.unsubscribeFromSeatOccupied(oldSeat)
        /// 이후 새로운 좌석 정보를 등록합니다
        try await seatRepository.registerSeat(newSeat)
        try await seatStompRepository.subscribeToSeatOccupied(newSeat)
    }
}
