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
        VStack {
            Spacer()

            SignInWithAppleButton(
                onRequest: viewModel.handleRequest,
                onCompletion: viewModel.handleCompletion
            )
            .frame(height: 50)

            Button {
                viewModel.action(.loginWithKakaoButtonTapped)
            } label: {
                Image("kakaoLoginButton", bundle: .module)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
        }
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    LoginView()
//}
