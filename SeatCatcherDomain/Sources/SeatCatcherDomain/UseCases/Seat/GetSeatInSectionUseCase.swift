//
//  GetSeatInSectionUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/15/25.
//

import Foundation

public protocol GetSeatInSectionUseCase: Sendable {
    func execute() async throws -> (topSeats: [Seat], bottomSeats: [Seat])
}

public final class GetSeatInSectionUseCaseImpl: GetSeatInSectionUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute() async throws -> (topSeats: [Seat], bottomSeats: [Seat]) {
        return try await seatRepository.getSeatsInSection()
    }
}
