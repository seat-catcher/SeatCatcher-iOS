//
//  GenerateNameView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/28/25.
//

import SwiftUI

public struct GenerateNameView: View {
    @State private var viewModel: GenerateNameViewModel

    public init(viewModel: GenerateNameViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            GenerateNameGuideTextView()
            GenerateNameDisplayView(viewModel: viewModel)
            Spacer()
            GenerateNameButtonGroupView(viewModel: viewModel)
        }
        .padding(.horizontal, 20)
        .applyToolbarVisibility(.hidden, for: .navigationBar)
        .withNavigationBar(viewModel.coordinator, isBackButtonHidden: true)
        .withBackground()
    }
}

private struct GenerateNameGuideTextView: View {
    var body: some View {
        Text("이름을 생성해주세요")
            .font(.system(size: 26, weight: .bold))
            .foregroundStyle(.white)
            .lineSpacing(4)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)

        Text("이름은 랜덤으로 생성돼요")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.gray)
            .lineSpacing(2)
            .padding(.bottom, 75)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct GenerateNameDisplayView: View {
    let viewModel: GenerateNameViewModel

    var body: some View {
        Text(viewModel.state.nickname)
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white)
            .lineSpacing(3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(.gray)
            .clipShape(.rect(cornerRadius: 12))
    }
}

private struct GenerateNameButtonGroupView: View {
    let viewModel: GenerateNameViewModel

    var body: some View {
        Button {
            viewModel.action(.regenerateButtonTapped)
        } label: {
            Text("재생성하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.gray)
                .baselineOffset(4)
                .underline()
        }
        .frame(alignment: .center)
        .padding(.bottom, 28)

        Button {
            viewModel.action(.nextButtonTapped)
        } label: {
            Text("다음")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .lineSpacing(2.5)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .padding(.bottom, 13)
                .background(.green)
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding(.bottom, 2)
    }
}
