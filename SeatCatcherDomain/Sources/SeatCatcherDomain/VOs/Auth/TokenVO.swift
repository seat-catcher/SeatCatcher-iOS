//
//  TokenVO.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/21/25.
//

import Foundation

public struct TokenVO: Sendable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
