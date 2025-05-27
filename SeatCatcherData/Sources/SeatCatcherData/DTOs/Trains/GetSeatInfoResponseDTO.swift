//
//  GetSeatInfoResponseDTO.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 5/27/25.
//

import Foundation

typealias GetSeatInfoResponseDTO = [SeatInCarInfo]

struct SeatInCarInfo: Decodable {
    let trainCode, carCode, seatGroupType: String
    let seatStatus: [SeatInfo]
}

struct SeatInfo: Decodable {
    let seatId, seatLocation: Int
    let seatType: String
    let occupant: OccupantInfo?
}

struct OccupantInfo: Decodable {
    let userId: Int
    let nickname: String
    let getOffRemainingCount: Int
}
