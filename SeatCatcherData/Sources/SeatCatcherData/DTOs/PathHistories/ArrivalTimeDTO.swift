//
//  ArrivalTimeDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 6/2/25.
//

struct ArrivalTimeDTO: Decodable {
    let id: Int
    let userId: Int
    let startStationId: Int
    let startStationName: String
    let endStationId: Int
    let endStationName: String
    let expectedArrivalTime: String
    let createdTime: String
}
