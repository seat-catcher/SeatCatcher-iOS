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
    typealias DomainModel = TokenVO

    static func stub() -> Self {
        return .init(accessToken: "accessToken", refreshToken: "refreshToken")
    }

    func toDomainModel() -> TokenVO {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
