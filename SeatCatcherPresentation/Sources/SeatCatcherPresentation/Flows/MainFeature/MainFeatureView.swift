//
//  MainFeatureView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/16/25.
//

import SwiftUI
import SeatCatcherCore

public struct MainFeatureView: View {
    @State private var viewModel: MainFeatureViewModel

    public init(viewModel: MainFeatureViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TitleTextView(seatSection: viewModel.state.seatSection)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)
                .padding(.bottom, 32)
            SeatSectionView(viewModel: viewModel.seatSectionViewModel)
                .padding(.bottom, 12)
            LookingCountView(count: viewModel.state.lookingCount)
            Spacer()
            ToastAlertView(
                seatSection: .normal_A,
                action: {
                    
                }
            )
            .padding(.bottom, 20)
            CTAButton(
                title: "내 좌석 관리하기",
                action: {
                    viewModel.action(.manageMySeatButtonDidTap)
                },
                style: .bottomMain
            )
            .padding(.bottom, 2)
        }
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .titleWithHomeButton(
                title: "좌석찾기",
                backButtonAction: { viewModel.action(.backButtonDidTap) },
                homeButtonAction: { viewModel.action(.homeButtonDidTap) }
            )
        )
    }
}

private struct TitleTextView: View {
    let seatSection: SeatSection
    
    var body: some View {
        VStack(spacing: 8) {
            Text(
                "\(seatSection.rawValue)에서\n원하는 좌석을 찾아보세요",
                styledSubstring: seatSection.rawValue,
                color: .scGreen,
                font: .T02_B
            )
            .font(.T02_B)
            .foregroundStyle(.gray100)
            Text("크레딧을 통해 좌석정보를 확인할 수 있어요")
                .font(.B03_M)
                .foregroundStyle(.gray300)
        }
    }
}

private struct LookingCountView: View {
    let count: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(.iconLooking)
                .frame(width: 24, height: 24)
            Text("\(count)명이 자리를 찾고 있어요")
                .font(.C01_M)
                .foregroundStyle(.gray400)
        }
        .padding(.horizontal, 10)
        .frame(height: 36)
        .background(
            Capsule()
                .fill(.clear)
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(.gray400, lineWidth: 1)
                .padding(0.5)
        )
    }
}

private struct ToastAlertView: View {
    let seatSection: SeatSection
    let action: () -> Void
    var body: some View {
        HStack(spacing: 0) {
            Image(.iconWarning)
                .frame(width: 24, height: 24)
                .padding(.trailing, 2)
            Text("좌석정보가 없어요")
                .font(.B03_M)
                .foregroundStyle(.scWhite)
                .padding(.trailing, 4)
            Button(
                action: action,
                label: {
                    Text("\(seatSection.rawValue)가기")
                        .underline()
                }
            )
            .font(.B03_M)
            .foregroundStyle(.scGreen)
            .underline(true)
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background(.gray500)
        .clipShape(Capsule())
    }
}
