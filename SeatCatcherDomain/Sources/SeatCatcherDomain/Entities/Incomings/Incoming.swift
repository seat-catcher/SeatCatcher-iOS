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
    public let arrivalTime: String
    public let destination: String

    public static func == (lhs: Incoming, rhs: Incoming) -> Bool {
        lhs.trainCode == rhs.trainCode
    }

    public init(trainCode: String, arrivalTime: String, destination: String) {
        self.trainCode = trainCode
        self.arrivalTime = arrivalTime
        self.destination = destination
    }
}
