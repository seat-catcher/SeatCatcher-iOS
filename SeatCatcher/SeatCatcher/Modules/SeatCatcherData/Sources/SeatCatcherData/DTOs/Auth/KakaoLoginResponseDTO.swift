//
//  KakaoLoginResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/23/25.
//

import Foundation
import SeatCatcherDomain

struct KakaoLoginResponseDTO {
    let accessToken: String
    let refreshToken: String
}

extension KakaoLoginResponseDTO: ResponseDTO {
    typealias DomainModel = Token

    static var stub: Self { .init(accessToken: "accessToken", refreshToken: "refreshToken") }

    var domainModel: Token { .init(accessToken: accessToken, refreshToken: refreshToken) }
}
