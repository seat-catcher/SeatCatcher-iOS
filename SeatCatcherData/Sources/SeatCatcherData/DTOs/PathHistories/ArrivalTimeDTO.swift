//
//  ArrivalTimeDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 6/2/25.
//

struct ArrivalTimeDTO: Decodable {
    let pathHistoryId: Int
    let expectedArrivalTime: String
    let nextScheduleTime: String?
    let arrived: Bool
}
