//
//  PathArrivalTime.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 6/5/25.
//

import Foundation

public struct PathArrivalTime: Sendable {
    public let pathHistoryId: Int
    public let expectedArrivalTime: Date
    public let arrived: Bool

    public init(pathHistoryId: Int, expectedArrivalTime: Date, arrived: Bool) {
        self.pathHistoryId = pathHistoryId
        self.expectedArrivalTime = expectedArrivalTime
        self.arrived = arrived
    }
}
