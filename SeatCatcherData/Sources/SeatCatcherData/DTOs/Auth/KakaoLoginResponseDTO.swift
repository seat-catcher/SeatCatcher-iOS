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
    typealias DomainModel = TokenVO

    static var stub: Self { .init(accessToken: "accessToken", refreshToken: "refreshToken") }

    var domainModel: TokenVO { .init(accessToken: accessToken, refreshToken: refreshToken) }
}
