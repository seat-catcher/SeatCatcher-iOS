//
//  AppleLoginRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol LoginRepository {
    func appleLogin(identityToken token: String, fcmToken: String, authorizationCode: String) async throws -> Token
    func kakaoLogin(fcmToken: String) async throws -> Token
}
