//
//  SelectLineView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/14/25.
//

import SwiftUI

public struct SelectLineView: View {
    @State private var viewModel: SelectLineViewModel

    public init(viewModel: SelectLineViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            TopGuidingText()
            SelectLineButtonsGroup(viewModel: viewModel)
            Spacer()
            CTAButton(
                title: "다음",
                action: { viewModel.action(.nextButtonTapped) },
                style: viewModel.state.selection == nil ? .bottomDisabled : .bottomEnabled
            )
            .disabled(viewModel.state.selection == nil)
        }
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .withBackground(.gray900)
        .withNavigationBar(viewModel.coordinator, config: .title(title: "좌석 찾기"))
    }
}

private struct TopGuidingText: View {
    var body: some View {
        Text("어떤 호선을 이용하세요?")
            .font(.T02_B)
            .foregroundStyle(.gray100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 18)
            .padding(.bottom, 54)
    }
}

private struct SelectLineButtonsGroup: View {
    let viewModel: SelectLineViewModel

    var body: some View {
        SelectLineButton(
            viewModel: viewModel,
            selection: .two,
            action: { viewModel.action(.lineNumber2ButtonTapped) }
        )

        Spacer().frame(height: 10)

        SelectLineButton(
            viewModel: viewModel,
            selection: .seven,
            action: { viewModel.action(.lineNumber7ButtonTapped) }
        )
    }
}

private struct SelectLineButton: View {
    let viewModel: SelectLineViewModel
    let selection: SelectLineViewModel.LineSelectionState
    let action: () -> Void

    var body: some View {
        Text("\(selection.rawValue)호선")
            .font(.B02_SB)
            .foregroundStyle(
                selection == viewModel.state.selection
                ? .scGreen
                : .gray300
            )
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                selection == viewModel.state.selection
                ? .scGreen700
                : .gray500
            )
            .clipShape(.rect(cornerRadius: 10))
            .onTapGesture(perform: action)
    }
}
