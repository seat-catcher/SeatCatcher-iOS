//
//  PostStartJourneyRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 6/1/25.
//

struct PostStartJourneyRequestDTO: RequestDTO {
    let startStationId: Int
    let endStationId: Int
    let trainCode: String
}
