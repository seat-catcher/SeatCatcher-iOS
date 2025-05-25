//
//  ManageSeatView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/25/25.
//

import SwiftUI

public struct ManageSeatView: View {
    
    @State private var viewModel: ManageSeatViewModel
    
    public init(viewModel: ManageSeatViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("현재 상황에 맞게\n착석 정보를 관리해 주세요")
                .font(.T02_B)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)
                .padding(.bottom, 20)
            VStack(spacing: 10) {
                ForEach(ManageSeatViewModel.ManageSeatOption.allCases, id: \.self) { option in
                    ManageSeatOptionView(viewModel: viewModel, option: option)
                }
            }
            Spacer()
            CTAButton(
                title: "다음",
                action: { viewModel.action(.didSelectOption) },
                style:
                    viewModel.state.selectedOption != nil ? .bottomEnabled : .bottomDisabled
            )
            .padding(.bottom, 2)
        }
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .titleWithHomeButton(
                title: "좌석 찾기",
                backButtonAction: { viewModel.action(.backButtonDidTap) },
                homeButtonAction: { viewModel.action(.homeButtonDidTap) },
                applyDefaultPopAction: false
            )
        )
    }
}

private struct ManageSeatOptionView: View {
    
    let viewModel: ManageSeatViewModel
    let option: ManageSeatViewModel.ManageSeatOption
    
    var body: some View {
        HStack(spacing: 2) {
            Image(option.icon)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundStyle(
                    viewModel.state.selectedOption == option
                    ? .scGreen
                    : .gray300
                )
            Text(option.rawValue)
                .font(.B02_SB)
                .foregroundStyle(
                    viewModel.state.selectedOption == option
                    ? .scGreen
                    : .gray300
                )
        }
        .withBackground(
            viewModel.state.selectedOption == option
            ? .scGreen700
            : .gray500
        )
        .frame(height: 60)
        .clipShape(.rect(cornerRadius: 10))
        .onTapGesture {
            viewModel.action(.willSelectOption(option))
        }
    }
}
