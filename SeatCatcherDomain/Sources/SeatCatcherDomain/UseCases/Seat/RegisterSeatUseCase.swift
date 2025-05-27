//
//  RegisterSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation

public protocol RegisterSeatUseCase: Sendable {
    func execute(_ seat: Seat) async throws
}

public final class RegisterSeatUseCaseImpl: RegisterSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(_ seat: Seat) async throws {
        try await seatRepository.registerSeat(seat)
    }
}
