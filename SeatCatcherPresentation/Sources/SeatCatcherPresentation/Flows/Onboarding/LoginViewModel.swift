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
        case loginSuccess
        case loginFailure
    }

    struct State {
        var isLoggedIn = false
        var errorMessage: String?
    }

    private(set) var state = State()
    private let loginUseCase: LoginUseCase
    private let coordinator: Coordinator

    public init(loginUseCase: LoginUseCase, coordinator: Coordinator) {
        self.loginUseCase = loginUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .loginWithKakaoButtonTapped:
            Task { [weak self] in
                guard let self = self else { return }
                if await loginWithKakao() {
                    self.action(.loginSuccess)
                } else {
                    self.action(.loginFailure)
                }
            }
        case .loginSuccess:
            print("hi")
        case .loginFailure:
            print("hi")
        }
    }

    /// 카카오 SDK에서 accessToken을 받아 오고, 해당 accessToken을 통해 서버와 로그인 로직 수행
    func loginWithKakao() async -> Bool {
        do {
            let token = try await loginUseCase.kakaoLogin()
            dump(token)
            return true
        } catch {
            dump(error)
            return false
        }
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

            // loginUseCase에 identityToken을 넘겨 서버와 로그인 로직 수행
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    let token = try await loginUseCase.appleLogin(identityToken: identityToken.base64EncodedString())
                    dump(token)
                    self.action(.loginSuccess)
                } catch {
                    dump(error)
                    self.action(.loginFailure)
                }
            }

        // 로컬에서 identityToken 받아오기 실패
        case let .failure(error):
            dump(error)
            self.action(.loginFailure)
        }
    }
}
