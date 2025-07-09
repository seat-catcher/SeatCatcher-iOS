//
//  Incoming.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/27/25.
//

import Foundation

public struct Incoming: Equatable, Identifiable, Sendable {
    public var id: String { trainCode }
    public let trainCode: String
    public let arrivalTime: Date
    public let carDirection: CarDirection
    public let destination: String

    public static func == (lhs: Incoming, rhs: Incoming) -> Bool {
        lhs.trainCode == rhs.trainCode
    }

    public init(trainCode: String, arrivalTime: Date, carDirection: CarDirection, destination: String) {
        self.trainCode = trainCode
        self.arrivalTime = arrivalTime
        self.carDirection = carDirection
        self.destination = destination
    }
}
