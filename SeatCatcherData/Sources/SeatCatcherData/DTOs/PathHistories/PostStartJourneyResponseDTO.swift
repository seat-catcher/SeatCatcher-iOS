//
//  PostStartJourneyResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 6/1/25.
//

import SeatCatcherDomain

struct PostStartJourneyResponseDTO {
    let pathHistoryId: Int
}

extension PostStartJourneyResponseDTO: ResponseDTO {
    typealias DomainModel = Int

    static var stub: PostStartJourneyResponseDTO {
        .init(pathHistoryId: 1)
    }
    
    var domainModel: Int { pathHistoryId }
}

