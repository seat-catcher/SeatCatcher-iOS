//
//  KakaoLoginRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/23/25.
//

import Foundation

struct KakaoLoginRequestDTO: RequestDTO {
    let accessToken: String
    let fcmToken: String
}
