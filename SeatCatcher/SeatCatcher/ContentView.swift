//
//  ContentView.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/6/25.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            SignInWithAppleButton {
                handleSignInWithAppleRequest($0)
            } onCompletion: {
                handleSignInWithAppleCompletion($0)
            }
        }
        .padding()
    }
}

// MARK: - Sign in with Apple 테스트
extension ContentView {
    private func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
    }

    private func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, any Error>) {
        switch result {
        case let .success(authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential
            else {
                dump("애플 로그인 credential 다운캐스팅 실패"); return
            }
            guard let idToken = credential.identityToken,
                  let authorizationCode = credential.authorizationCode
            else {
                dump("토큰 정보 없음"); return
            }

            dump("identityToekn: \(String(data: idToken, encoding: .utf8)!)")
            dump("authorizationCode: \(String(data: authorizationCode, encoding: .utf8)!)")
            dump("user: \(credential.user)")
            dump("email: \(credential.email ?? "이메일 없음")")
        case let .failure(error):
            dump("애플 로그인 에러: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
