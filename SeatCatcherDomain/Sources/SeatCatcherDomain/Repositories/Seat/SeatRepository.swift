//
//  SeatRepository.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/18/25.
//

import Foundation

public protocol SeatRepository: Sendable {
    func getSeatsInSection() async throws -> (topSeats: [Seat], bottomSeats: [Seat])
    func unlockAllSeats() async throws
}
