//
//  UserGreetingView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 4/10/25.
//

import SwiftUI

public struct UserGreetingView: View {
    @State private var viewModel: UserGreetingViewModel

    public init(viewModel: UserGreetingViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            Group {
                Spacer().frame(height: 167)

                Image(viewModel.user.profileImage.image)

                Spacer().frame(height: 30)

                Text("\(viewModel.user.name)님\n반가워요")
                    .font(.T01_SB)
                    .foregroundStyle(.scWhite)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 16)

                Text("닉네임과 프로필 사진은\n언제든지 변경할 수 있어요")
                    .font(.B03_M)
                    .foregroundStyle(.gray300)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .opacity(viewModel.state.isPresented ? 1 : 0)
            .animation(.easeInOut(duration: 0.4), value: viewModel.state.isPresented)
        }
        .withBackground(.gray900)
        .applyToolbarVisibility(.hidden, for: .navigationBar)
        .onAppear { viewModel.action(.fadeOut) }
    }
}
