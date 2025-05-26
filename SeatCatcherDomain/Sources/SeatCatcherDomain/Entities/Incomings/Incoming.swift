//
//  Incoming.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/27/25.
//

import Foundation

public struct Incoming: Sendable {
    public let trainCode: String
    public let arrivalTime: String
    public let destination: String

    public init(trainCode: String, arrivalTime: String, destination: String) {
        self.trainCode = trainCode
        self.arrivalTime = arrivalTime
        self.destination = destination
    }
}
