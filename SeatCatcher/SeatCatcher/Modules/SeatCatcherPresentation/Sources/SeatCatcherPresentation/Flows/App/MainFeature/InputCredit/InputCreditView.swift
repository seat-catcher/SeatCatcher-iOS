//
//  InputCreditView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 7/9/25.
//

import SwiftUI

public struct InputCreditView: View {
    @State private var viewModel: InputCreditViewModel

    public init(viewModel: InputCreditViewModel) {
        self._viewModel = .init(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            TopGuidingText()
            CreditInputField(viewModel: viewModel)
            Spacer()
            CTAButton(
                title: "양보 요청하기",
                action: { viewModel.action(.requestButtonDidTap) },
                style: viewModel.state.isCreditValid ? .bottomEnabled : .bottomDisabled
            )
            .disabled(!viewModel.state.isCreditValid)
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .titleWithHomeButton(title: "좌석 찾기")
        )
        // MARK: - TextField 바인딩 버그로 인해, onChange로 필터링 로직 이관
        .onChange(of: viewModel.state.credit) { filterCredit($1) }
    }

    // MARK: - TextField 바인딩 버그로 인해, onChange로 필터링 로직 이관
    private func filterCredit(_ input: String) {
        guard let credit = Int(input) else {
            let filteredCredit = input.filter(\.isNumber)
            viewModel.action(.creditChanged(String(filteredCredit)))
            return
        }
        viewModel.action(.creditChanged(String(credit)))
    }
}

private struct TopGuidingText: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("지불할 크레딧을 입력해주세요")
                .font(.T01_SB)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("가지고 있는 크레딧 안에서 지불할 수 있어요")
                .font(.B02_M)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 20)
        .padding(.bottom, 85)
    }
}

private struct CreditInputField: View {
    @FocusState private var isFocused: Bool
    @Bindable var viewModel: InputCreditViewModel

    var body: some View {
        VStack(spacing: 10) {
            TextField(
                "",
                text: Binding(
                    get: { viewModel.state.credit },
                    set: { viewModel.action(.creditChanged($0)) }
                ),
                prompt: Text("크레딧 입력하기").font(.T03_SB).foregroundStyle(.gray500)
            )
            .font(.T03_SB)
            .foregroundStyle(.gray100)
            .focused($isFocused)
            .keyboardType(.numberPad)

            Capsule().fill(borderColor).frame(height: 1.5)

            if viewModel.state.isCreditExceeded {
                Text("크레딧이 부족해요")
                    .font(.C01_M)
                    .foregroundStyle(.gray200)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var borderColor: Color {
        if viewModel.state.credit.isEmpty { return .gray300 }
        return viewModel.state.isCreditExceeded ? .actionBad : .scGreen
    }
}
