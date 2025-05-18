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
        .init(
            id: 1,
            startStationId: 1704,
            startStationName: "사당",
            startline: "LINE_2",
            endStationId: 1715,
            endStationName: "당산",
            endline: "LINE_2",
            expectedArrivalTime: "09-23",
            createdDate: "09-23"
        )
    }

    var domainModel: PathHistory {
        .init(
            id: id,
            line: line,
            departureStationId: startStationId,
            departureStationName: startStationName,
            arrivalStationId: endStationId,
            arrivalStationName: endStationName,
            createdDate: createdDate
        )
    }

    var line: Int {
        switch self.startline {
        case "LINE_1": return 1
        case "LINE_2": return 2
        case "LINE_3": return 3
        case "LINE_4": return 4
        case "LINE_5": return 5
        case "LINE_6": return 6
        case "LINE_7": return 7
        case "LINE_8": return 8
        case "LINE_9": return 9
        default: return 2
        }
    }

    let id: Int
    let startStationId: Int
    let startStationName: String
    let startline: String
    let endStationId: Int
    let endStationName: String
    let endline: String
    let expectedArrivalTime: String
    let createdDate: String
}
