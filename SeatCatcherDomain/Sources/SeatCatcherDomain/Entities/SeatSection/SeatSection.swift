//
//  SeatSection.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/20/25.
//

import Foundation

public struct SeatSection: Sendable {
    public init(type: SeatSectionType, topSeats: [Int:Seat], bottomSeats: [Int:Seat]) {
        self.type = type
        self.topSeats = topSeats
        self.bottomSeats = bottomSeats
    }
    
    public var type: SeatSectionType
    public var topSeats: [Int:Seat]
    public var bottomSeats: [Int:Seat]
}
