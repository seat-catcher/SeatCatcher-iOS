//
//  PatchCreditRequestDTO.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 6/12/25.
//

import Foundation

struct PatchCreditRequestDTO: RequestDTO {
    let amount: Int
    let targetUserId: Int
}
