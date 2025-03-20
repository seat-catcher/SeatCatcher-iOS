//
//  File.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/19/25.
//

import Foundation
import AuthenticationServices
import SeatCatcherDomain
import SeatCatcherCore

@Observable
public final class LoginViewModel: ViewModel {
    enum Action {
        case loginSuccess
        case loginFailure
    }

    struct State {
        var isLoggedIn = false
        var errorMessage: String?
    }

    private(set) var state = State()
    private let appleLoginUseCase: AppleLoginUseCase
    private let coordinator: Coordinator

    public init(appleLoginUseCase: AppleLoginUseCase, coordinator: Coordinator) {
        self.appleLoginUseCase = appleLoginUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .loginSuccess:
            print("hi")
        case .loginFailure:
            print("hi")
        }
    }

    func handleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    @MainActor
    func handleCompletion(_ result: Result<ASAuthorization, any Error>) {
        switch result {
        case let .success(authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityToken = credential.identityToken
            else { return }
            Task {
                do {
                    let token = try await appleLoginUseCase.login(identityToken: identityToken.base64EncodedString())
                    dump(token?.accessToken)
                    dump(token?.refreshToken)
                } catch {
                    dump(error)
                }
            }

        case let .failure(error):
            dump(error)
        }
    }
}
