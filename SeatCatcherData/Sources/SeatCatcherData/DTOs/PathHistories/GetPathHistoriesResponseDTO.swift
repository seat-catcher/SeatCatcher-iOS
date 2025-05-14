//
//  GetPathHistoriesResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/15/25.
//

import SeatCatcherDomain

struct GetPathHistoriesResponseDTO: ResponseDTO {
    typealias DomainModel = [PathHistory]

    static var stub: Self {
        .init(pathHistoryInfoList: [], nextCursor: -1, last: true)
    }

    var domainModel: [PathHistory] {
        pathHistoryInfoList.compactMap { $0.domainModel }
    }

    let pathHistoryInfoList: [GetPathHistoriesContentsResponseDTO]
    let nextCursor: Int
    let last: Bool
}

struct GetPathHistoriesContentsResponseDTO: ResponseDTO {
    typealias DomainModel = PathHistory

    static var stub: Self {
        .init(id: 1, startStationId: 1704, startStationName: "사당", endStationId: 1715, endStationName: "당산", expectedArrivalTime: "09-23", createdDate: "09-23")
    }

    var domainModel: PathHistory {
        .init(id: id, line: nil, departureStationId: startStationId, departureStationName: startStationName, arrivalStationId: endStationId, arrivalStationName: endStationName, createdDate: createdDate)
    }

    let id: Int
    let startStationId: Int
    let startStationName: String
    let endStationId: Int
    let endStationName: String
    let expectedArrivalTime: String
    let createdDate: String
}
