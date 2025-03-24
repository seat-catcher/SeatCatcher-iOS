//
//  AppleLoginUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol LoginUseCase {
    func appleLogin(identityToken token: String) async throws -> Token
    func kakaoLogin() async throws -> Token
}

public final class LoginUseCaseImpl: LoginUseCase {
    private let loginRepository: LoginRepository

    public init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }

    public func appleLogin(identityToken token: String) async throws -> Token {
        return try await loginRepository.appleLogin(identityToken: token)
    }

    public func kakaoLogin() async throws -> Token {
        return try await loginRepository.kakaoLogin()
    }
}
