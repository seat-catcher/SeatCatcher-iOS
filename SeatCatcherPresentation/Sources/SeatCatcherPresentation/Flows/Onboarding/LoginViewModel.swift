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
        case loginWithKakaoButtonTapped
        case loginFailure(Error)
    }

    struct State {
        var isLoggedIn = false
        var errorMessage: String?
    }

    private(set) var state = State()
    private let authUseCase: AuthUseCase
    private let coordinator: Coordinator

    public init(
        authUseCase: AuthUseCase,
        coordinator: Coordinator
    ) {
        self.authUseCase = authUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .loginWithKakaoButtonTapped:
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    try await authUseCase.kakaoLogin()
                } catch {
                    self.action(.loginFailure(error))
                }
            }
        case let .loginFailure(error):
            dump(error)
            state.errorMessage = error.localizedDescription
        }
    }

    /// 카카오 SDK에서 accessToken을 받아 오고, 해당 accessToken을 통해 서버와 로그인 로직 수행
    func loginWithKakao() async throws {
        try await authUseCase.kakaoLogin()
    }

    /// 애플 로그인 리퀘스트 파라미터 설정
    func handleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    /// 애플 로그인(Local) 수행 결과 핸들링 후 서버와 로그인 로직 수행
    @MainActor
    func handleCompletion(_ result: Result<ASAuthorization, any Error>) {
        switch result {
        // 로컬에서 identityToken 받아오기 성공
        case let .success(authorization):
            // identityToken 언래핑
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityToken = credential.identityToken
            else { return }

            // authUseCase에 identityToken을 넘겨 서버와 로그인 로직 수행
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    try await authUseCase.appleLogin(identityToken: identityToken.base64EncodedString())
                } catch {
                    self.action(.loginFailure(error))
                }
            }

        // 로컬에서 identityToken 받아오기 실패
        case let .failure(error):
            self.action(.loginFailure(error))
        }
    }
}
