//
//  SeatSection.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/20/25.
//

import Foundation

public struct SeatSection: Sendable, Equatable {
    public static func == (lhs: SeatSection, rhs: SeatSection) -> Bool {
        lhs.topSeats == rhs.topSeats
        && lhs.bottomSeats == rhs.bottomSeats 
    }
    
    public init(topSeats: [Int:Seat], bottomSeats: [Int:Seat]) {
        self.topSeats = topSeats
        self.bottomSeats = bottomSeats
    }
    
    public var topSeats: [Int:Seat]
    public var bottomSeats: [Int:Seat]
}
