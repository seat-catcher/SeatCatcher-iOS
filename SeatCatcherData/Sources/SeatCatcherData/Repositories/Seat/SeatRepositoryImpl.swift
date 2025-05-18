//
//  SeatRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 5/18/25.
//

import Foundation
import SeatCatcherDomain

public final class SeatRepositoryImpl: SeatRepository, Sendable {
    
    // TODO: Service 연결
    public init() {}
    
    public func getSeatsInSection() async throws -> (topSeats: [Seat], bottomSeats: [Seat]) {
        // TODO: API 엔드포인트 연결
        let topSeats: [Seat] = [
            Seat(minutesLeft: 30, isAvailable: false, isVisible: true, isSeated: false, isBlocked: false, seatDirection: .top),
            Seat(minutesLeft: 20, isAvailable: false, isVisible: true, isSeated: false, isBlocked: false, seatDirection: .top),
            Seat(minutesLeft: 0, isAvailable: false, isVisible: true, isSeated: false, isBlocked: true, seatDirection: .top),
            Seat(minutesLeft: 15, isAvailable: false, isVisible: true, isSeated: true, isBlocked: false, seatDirection: .top),
            Seat(minutesLeft: 8, isAvailable: false, isVisible: false, isSeated: false, isBlocked: false, seatDirection: .top),
            Seat(minutesLeft: 3, isAvailable: false, isVisible: true, isSeated: false, isBlocked: true, seatDirection: .top),
            Seat(minutesLeft: 20, isAvailable: true, isVisible: true, isSeated: false, isBlocked: false, seatDirection: .top)
        ]
        
        let bottomSeats: [Seat] = [
            Seat(minutesLeft: 12, isAvailable: true, isVisible: true, isSeated: false, isBlocked: false, seatDirection: .bottom),
            Seat(minutesLeft: 7, isAvailable: true, isVisible: true, isSeated: true, isBlocked: false, seatDirection: .bottom),
            Seat(minutesLeft: 2, isAvailable: false, isVisible: true, isSeated: false, isBlocked: true, seatDirection: .bottom),
            Seat(minutesLeft: 18, isAvailable: true, isVisible: true, isSeated: false, isBlocked: false, seatDirection: .bottom),
            Seat(minutesLeft: 9, isAvailable: true, isVisible: true, isSeated: false, isBlocked: false, seatDirection: .bottom),
            Seat(minutesLeft: 4, isAvailable: false, isVisible: true, isSeated: false, isBlocked: true, seatDirection: .bottom),
            Seat(minutesLeft: 25, isAvailable: false, isVisible: false, isSeated: false, isBlocked: false, seatDirection: .bottom)
        ]
        return (topSeats, bottomSeats)
    }
    
    public func unlockAllSeats() async throws {
        // TODO: API 엔드포인트 연결
        return
    }
    
}
