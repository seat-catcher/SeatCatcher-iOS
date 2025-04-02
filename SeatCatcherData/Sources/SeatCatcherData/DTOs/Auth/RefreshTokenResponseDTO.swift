//
//  RefreshTokenResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 4/2/25.
//

import SeatCatcherDomain

struct RefreshTokenResponseDTO {
    let accessToken: String
    let refreshToken: String
}

extension RefreshTokenResponseDTO: ResponseDTO {
    typealias DomainModel = TokenVO

    static var stub: Self { .init(accessToken: "accessToken", refreshToken: "accessToken") }

    var domainModel: TokenVO { .init(accessToken: accessToken, refreshToken: refreshToken) }
}
