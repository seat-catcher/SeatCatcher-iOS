//
//  NextView.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/14/25.
//

import SwiftUI
import AuthenticationServices

public struct LoginView: View {
    @State private var viewModel: LoginViewModel

    public init(viewModel: LoginViewModel) {
        self._viewModel = .init(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
            LogoHeaderView()
                .padding(.bottom, 52)
            LoginButtonGroupView(viewModel: viewModel)
                .padding(.bottom, 199)
        }
        .padding(.horizontal, 20)
        .withBackground(.gray900)
    }
}

private struct LogoHeaderView: View {
    var body: some View {
        VStack(spacing: 23) {
            Image(.scOnboaringLogo)
            Image(.scTextLogo)
        }
    }
}

private struct LoginButtonGroupView: View {
    let viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.action(.loginWithKakaoButtonTapped)
            } label: {
                HStack(spacing: 7) {
                    Spacer()

                    Image(.kakaoLogo)
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(Color(red: 0.22, green: 0.11, blue: 0.11))
                        .frame(width: 14, height: 14)

                    Text("카카오로 계속하기")
                        .foregroundStyle(Color(red: 0.22, green: 0.11, blue: 0.11))
                        .font(.system(size: 20, weight: .medium))

                    Spacer()
                }
                .padding(.vertical, 12)
                .frame(height: 52)
                .background(Color(red: 0.98, green: 0.88, blue: 0))
                .clipShape(.rect(cornerRadius: 8))
            }

            SignInWithAppleButton(
                .continue,
                onRequest: viewModel.handleRequest,
                onCompletion: viewModel.handleCompletion
            )
            .signInWithAppleButtonStyle(.white)
            .frame(height: 52)
        }
    }
}

//#Preview {
//    LoginView()
//}
