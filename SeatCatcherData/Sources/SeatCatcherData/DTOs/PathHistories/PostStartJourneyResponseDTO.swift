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
}

extension PostStartJourneyResponseDTO: ResponseDTO {
    typealias DomainModel = (pathHistoryId: Int, expectedArrivalTime: Date)

    static var stub: PostStartJourneyResponseDTO {
        .init(pathHistoryId: 1, expectedArrivalTime: Date().addingTimeInterval(600).formatted())
    }
    
    var domainModel: (pathHistoryId: Int, expectedArrivalTime: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        dump(expectedArrivalTime)
        if let expectedArrivalTime = formatter.date(from: expectedArrivalTime) {
            return (pathHistoryId: pathHistoryId, expectedArrivalTime: expectedArrivalTime)
        } else {
            return (pathHistoryId: pathHistoryId, expectedArrivalTime: Date().addingTimeInterval(600))
        }
    }
}

