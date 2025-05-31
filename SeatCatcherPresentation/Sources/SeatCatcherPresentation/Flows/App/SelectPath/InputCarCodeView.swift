//
//  InputCarCodeView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/31/25.
//

import SwiftUI

public struct InputCarCodeView: View {
    @State private var viewModel: InputCarCodeViewModel

    public init(viewModel: InputCarCodeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            GuidingText()
            CodeInputField(viewModel: viewModel)
            Spacer()
            NextCTAButton(viewModel: viewModel)
        }
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .titleWithHomeButton(title: "좌석 찾기")
        )
    }
}

private struct GuidingText: View {
    var body: some View {
        Text("탑승칸의 차량번호를\n입력해주세요")
            .font(.T02_B)
            .foregroundStyle(.gray100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 18)
            .padding(.horizontal, 18)

        Text("차량번호는 탑승칸의 문을 확인해주세요")
            .font(.B02_M)
            .foregroundStyle(.gray300)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            .padding(.horizontal, 18)
    }
}

struct CodeInputField: View {
    let viewModel: InputCarCodeViewModel
    @FocusState var digitsFocusState: DigitsFocusState?

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { idx in
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.clear)
                        .stroke(viewModel.state.carCodeDigits[idx].isEmpty ? .gray100 : .scGreen, lineWidth: 4)
                        .frame(width: 70, height: 70)
                        .clipShape(.rect(cornerRadius: 8))
                    TextField(
                        "",
                        text: .init(
                            get: { viewModel.state.carCodeDigits[idx] },
                            set: { viewModel.action(.digitChanged($0, idx)) }
                        ),
                        prompt: Text("0").font(.DIGIT).foregroundStyle(.gray500)
                    )
                    .font(.DIGIT)
                    .keyboardType(.numberPad)
                    .foregroundStyle(.gray100)
                    .fixedSize()
                    .focused($digitsFocusState, equals: .init(rawValue: idx) ?? .isFocusedFirst)
                    .onChange(of: viewModel.state.carCodeDigits[idx]) { _, newValue in
                        filterDigits(digit: newValue, idx: idx)
                        moveFocusState(idx)
                    }
                }
            }
        }
        .padding(.top, 102)
        .onAppear { digitsFocusState = .isFocusedFirst }
    }

    private func filterDigits(digit: String, idx: Int) {
        var filtered = digit.filter { $0.isNumber }
        if filtered.count <= 1  { viewModel.action(.digitChanged(filtered, idx)) }
        else { viewModel.action(.digitChanged(String(filtered.removeLast()), idx)) }
    }


    private func moveFocusState(_ index: Int) {
        if viewModel.state.carCodeDigits[index].isEmpty {
            moveToPreviousFocusState(index)
        } else {
            moveToNextFocusState(index)
        }
    }

    private func moveToNextFocusState(_ index: Int) {
        if index == 3 {
            digitsFocusState = nil
            return
        }
        digitsFocusState = .init(rawValue: index + 1)
    }

    private func moveToPreviousFocusState(_ index: Int) {
        if index == 0 {
            digitsFocusState = nil
            return
        }
        digitsFocusState = .init(rawValue: index - 1)
    }
}

extension CodeInputField {
    enum DigitsFocusState: Int {
        case isFocusedFirst = 0
        case isFocusedSecond
        case isFocusedThird
        case isFocusedFourth
    }
}

private struct NextCTAButton: View {
    let viewModel: InputCarCodeViewModel
    var body: some View {
        Button {
            viewModel.action(.nextButtonTapped)
        } label: {
            Text("탑승칸 안 내 구역 찾기")
                .font(.B01_SB)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(.scGreen)
        }
    }
}

