//
//  File.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/21/25.
//

import Foundation
import SeatCatcherDomain

struct AppleLoginResponseDTO {
    let accessToken: String
    let refreshToken: String
}

extension AppleLoginResponseDTO: ResponseDTO {
    typealias DomainModel = Token

    static var stub: Self { .init(accessToken: "accessToken", refreshToken: "refreshToken") }

    var domainModel: Token { .init(accessToken: accessToken, refreshToken: refreshToken) }
}
