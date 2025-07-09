//
//  KakaoLoginRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/23/25.
//

import Foundation

struct KakaoLoginRequestDTO: RequestDTO {
    let accessToken: String
    let fcmToken = UUID().uuidString // TODO: - 임시 FCM 토큰 교체
}
