//
//  MoveSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation

public protocol MoveSeatUseCase: Sendable {
    func execute(_ seat: Seat) async throws
}

public final class MoveSeatUseCaseImpl: MoveSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(_ seat: Seat) async throws {
        try await seatRepository.moveSeat(seat)
    }
}
