//
//  Seat.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 4/16/25.
//

import Foundation

public struct Seat: Sendable {
    public var minutesLeft: Int
    public var isAvailable: Bool
    public var isSelected: Bool
    public var isSeated: Bool
    public var hasDibsOn: Bool
    public var seatDirection: SeatDirection

    public init(
        minutesLeft: Int = 0,
        isAvailable: Bool = true,
        isSelected: Bool = false,
        isSeated: Bool = false,
        hasDibsOn: Bool = false,
        seatDirection: SeatDirection
    ) {
        self.minutesLeft = minutesLeft
        self.isAvailable = isAvailable
        self.isSelected = isSelected
        self.isSeated = isSeated
        self.hasDibsOn = hasDibsOn
        self.seatDirection = seatDirection
    }
}

public enum SeatDirection: Sendable {
    case top
    case bottom
}
