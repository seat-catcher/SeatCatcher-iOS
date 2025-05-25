//
//  SelectBoardingStateView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/25/25.
//

import SwiftUI

public struct SelectBoardingStateView: View {
    @State private var viewModel: SelectBoardingStateViewModel

    public init(viewModel: SelectBoardingStateViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            GuidingText()
                .padding(.top, 18)
                .padding(.bottom, 54)
            SelectionButtonGroup(viewModel: viewModel)
            Spacer()
            CTAButton(title: "다음", action: {}, style: .bottomEnabled)
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
        .withNavigationBar(viewModel.coordinator, config: .titleWithHomeButton(title: "좌석 찾기"))
    }
}

private struct GuidingText: View {
    var body: some View {
        Text("지하철에 탑승 중이세요?")
            .font(.T02_B)
            .foregroundStyle(.gray100)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SelectionButtonGroup: View {
    let viewModel: SelectBoardingStateViewModel

    var body: some View {
        VStack(spacing: 10) {
            Button {
                viewModel.action(.hasNotBoardedButtonTapped)
            } label: {
                Text("아직 탑승 안했어요")
                    .font(.B02_SB)
                    .foregroundStyle(
                        viewModel.state.boardingState == .notBoarded
                        ? .scGreen
                        : .gray300
                    )
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(
                        viewModel.state.boardingState == .notBoarded
                        ? .scGreen700
                        : .gray500
                    )
                    .clipShape(.rect(cornerRadius: 10))
            }

            Button {
                viewModel.action(.hasBoardButtonTapped)
            } label: {
                Text("이미 탑승했어요")
                    .font(.B02_SB)
                    .foregroundStyle(
                        viewModel.state.boardingState == .boarded
                        ? .scGreen
                        : .gray300)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(
                        viewModel.state.boardingState == .boarded
                        ? .scGreen700
                        : .gray500
                    )
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
}
