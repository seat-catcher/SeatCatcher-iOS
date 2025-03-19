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
        SignInWithAppleButton(
            onRequest: viewModel.handleRequest,
            onCompletion: viewModel.handleCompletion
        )
    }
}

//#Preview {
//    LoginView()
//}
