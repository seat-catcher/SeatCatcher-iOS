//
//  PathHistory.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/15/25.
//

public struct PathHistory: Sendable, Identifiable {
    public let id: Int
    public var line: Int?
    public let departureStationId: Int
    public let departureStationName: String
    public let arrivalStationId: Int
    public let arrivalStationName: String
    public let createdDate: String

    public init(
        id: Int,
        line: Int?,
        departureStationId: Int,
        departureStationName: String,
        arrivalStationId: Int,
        arrivalStationName: String,
        createdDate: String
    ) {
        self.id = id
        self.line = line
        self.departureStationId = departureStationId
        self.departureStationName = departureStationName
        self.arrivalStationId = arrivalStationId
        self.arrivalStationName = arrivalStationName
        self.createdDate = createdDate
    }
}
