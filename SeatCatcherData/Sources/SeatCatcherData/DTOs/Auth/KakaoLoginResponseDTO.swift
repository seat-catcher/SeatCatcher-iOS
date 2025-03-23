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
    typealias Entity = Token

    static func stub() -> Self {
        return .init(accessToken: "accessToken", refreshToken: "refreshToken")
    }

    func toEntity() -> Token {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
