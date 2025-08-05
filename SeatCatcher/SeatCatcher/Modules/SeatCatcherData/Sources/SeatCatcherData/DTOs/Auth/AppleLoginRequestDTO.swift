//
//  AppleLoginRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/21/25.
//

import Foundation

struct AppleLoginRequestDTO: RequestDTO {
    let identityToken: String
    let fcmToken: String
    let authorizationCode: String
    let nonce: String
}
