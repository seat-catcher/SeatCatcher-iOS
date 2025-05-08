//
//  AppleLoginRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/21/25.
//

import Foundation

struct AppleLoginRequestDTO: RequestDTO {
    let identityToken: String
    let fcmToken = UUID().uuidString // TODO: - 임시 FCM 토큰 교체
}
