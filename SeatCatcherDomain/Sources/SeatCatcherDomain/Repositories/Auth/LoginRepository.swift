//
//  AppleLoginRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol LoginRepository {
    func appleLogin(identityToken token: String) async throws -> TokenVO
    func kakaoLogin() async throws -> TokenVO
}
