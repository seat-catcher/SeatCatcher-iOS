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
    private let appStore: AppStore
    private let kakaoLoginUseCase: KakaoLoginUseCase
    private let appleLoginUseCase: AppleLoginUseCase
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let coordinator: Coordinator

    public init(
        appStore: AppStore,
        kakaoLoginUseCase: KakaoLoginUseCase,
        appleLoginUseCase: AppleLoginUseCase,
        getUserInfoUseCase: GetUserInfoUseCase,
        coordinator: Coordinator
    ) {
        self.appStore = appStore
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.appleLoginUseCase = appleLoginUseCase
        self.getUserInfoUseCase = getUserInfoUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .loginWithKakaoButtonTapped:
            Task {
                do {
                    try await kakaoLoginUseCase.execute()
                } catch {
                    self.action(.loginFailure(error))
                }
            }
        case let .loginFailure(error):
            state.errorMessage = error.localizedDescription
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

            // authUseCase에 identityToken을 넘겨 서버와 로그인 로직 수행
            Task {
                do {
                    try await appleLoginUseCase.execute(identityToken: identityToken.base64EncodedString())
                    appStore.setUser(try await getUserInfoUseCase.execute())
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
