//
//  InputCarCodeGuidingView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/27/25.
//

import SwiftUI

public struct InputCarCodeGuidingView: View {
    @State private var viewModel: InputCarCodeGuidingViewModel

    public init(viewModel: InputCarCodeGuidingViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text("탑승 후, 탑승칸의\n차량번호를 입력할 거예요")
                .font(.T02_B)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)
                .padding(.horizontal, 18)

            Image(.inputCodeGuiding)
                .resizable()
                .scaledToFit()
                .padding(.top, 32)

            Spacer()

            CTAButton(
                title: "확인",
                action: { viewModel.action(.nextButtonTapped) },
                style: .bottomEnabled
            )
            .padding(.horizontal, 18)
        }
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .titleWithHomeButton(title: "좌석 찾기")
        )
    }
}
