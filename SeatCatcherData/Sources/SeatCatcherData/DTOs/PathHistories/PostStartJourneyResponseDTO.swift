//
//  PostStartJourneyResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 6/1/25.
//

import Foundation
import SeatCatcherDomain

struct PostStartJourneyResponseDTO {
    let pathHistoryId: Int
    let expectedArrivalTime: String
    let nextScheduleTime: String
    let arrived: Bool
}

extension PostStartJourneyResponseDTO: ResponseDTO {
    typealias DomainModel = (pathHistoryId: Int, expectedArrivalTime: Date)

    static var stub: PostStartJourneyResponseDTO {
        .init(pathHistoryId: 1, expectedArrivalTime: Date().addingTimeInterval(600).formatted(), nextScheduleTime: "", arrived: false)
    }
    
    var domainModel: (pathHistoryId: Int, expectedArrivalTime: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let expectedArrivalTime = formatter.date(from: expectedArrivalTime)
        else { return (pathHistoryId: pathHistoryId, expectedArrivalTime: Date().addingTimeInterval(600)) }
        return (pathHistoryId: pathHistoryId, expectedArrivalTime: expectedArrivalTime)
    }
}

