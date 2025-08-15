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
    private let store: AppStore
    private let kakaoLoginUseCase: KakaoLoginUseCase
    private let appleLoginUseCase: AppleLoginUseCase
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let coordinator: Coordinator
    
    public init(
        store: AppStore,
        kakaoLoginUseCase: KakaoLoginUseCase,
        appleLoginUseCase: AppleLoginUseCase,
        getUserInfoUseCase: GetUserInfoUseCase,
        coordinator: Coordinator
    ) {
        self.store = store
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.appleLoginUseCase = appleLoginUseCase
        self.getUserInfoUseCase = getUserInfoUseCase
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .loginWithKakaoButtonTapped:
            Task { [kakaoLoginUseCase, getUserInfoUseCase] in
                do {
                    try await kakaoLoginUseCase.execute()
                    let user = try await getUserInfoUseCase.execute()
                    store.setUser(user)
                } catch { self.action(.loginFailure(error)) }
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
        case let .success(authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityTokenData = credential.identityToken,
                  let identityTokenString = String(data: identityTokenData, encoding: .utf8),
                  let authorizationCodeString = String(data: credential.authorizationCode ?? Data(), encoding: .utf8)
            else { return }
            
            // Decode the JWT payload
            let decodedPayload = decodeJWTPayload(identityTokenString) ?? identityTokenString
            
            Task { [appleLoginUseCase, getUserInfoUseCase] in
                do {
                    try await appleLoginUseCase.execute(identityToken: decodedPayload, authorizationCode: authorizationCodeString)
                    let user = try await getUserInfoUseCase.execute()
                    store.setUser(user)
                } catch { self.action(.loginFailure(error)) }
            }
        case let .failure(error):
            self.action(.loginFailure(error))
        }
    }
    
    // Helper function to decode JWT payload
    private func decodeJWTPayload(_ token: String) -> String? {
        let parts = token.split(separator: ".")
        guard parts.count == 3,
              let payloadData = Data(base64Encoded: String(parts[1]), options: .ignoreUnknownCharacters),
              let decodedPayload = String(data: payloadData, encoding: .utf8) else {
            return nil // Return nil if decoding fails
        }
        return decodedPayload
    }
}
