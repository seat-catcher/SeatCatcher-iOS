//
//  PostRegisterSeatRequestDTO.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 5/28/25.
//

import Foundation

struct PostRegisterSeatRequestDTO: RequestDTO {
    let seatId: Int
    let creditAmount: Int
}
