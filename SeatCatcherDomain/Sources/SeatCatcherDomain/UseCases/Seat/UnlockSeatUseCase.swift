//
//  UnlockSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/15/25.
//

import Foundation

public protocol UnlockSeatUseCase: Sendable {
    func execute() async throws
}

public final class UnlockSeatUseCaseImpl: UnlockSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute() async throws {
        try await seatRepository.unlockAllSeats()
    }
}
