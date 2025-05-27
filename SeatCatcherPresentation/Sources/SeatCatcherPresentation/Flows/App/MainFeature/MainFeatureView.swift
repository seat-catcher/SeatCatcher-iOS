//
//  MainFeatureView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/16/25.
//

import SwiftUI
import SeatCatcherCore
import SeatCatcherDomain

public struct MainFeatureView: View {
    @State private var viewModel: MainFeatureViewModel

    public init(viewModel: MainFeatureViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TitleTextView(seatSection: viewModel.state.seatSection, status: viewModel.state.userStatus)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)
                .padding(.bottom, 32)
            SeatSectionView(
                selectedSeat: viewModel.state.seatSectionState.selectedSeat,
                isBlocked: viewModel.state.seatSectionState.isBlocked,
                seats: viewModel.state.seatSectionState.seats,
                userStatus: viewModel.state.userStatus,
                onTap: { seat in
                    viewModel.action(.manageSeatSection(.willSelectSeat(seat)))
                }
            )
            .padding(.bottom, 12)
            if viewModel.state.lookingCount > 0 {
                LookingCountView(count: viewModel.state.lookingCount)
            }
            Spacer()
            if viewModel.state.showNoInformationToast {
                ToastAlertView(
                    action: {
                        viewModel.action(.backToSeatSectionPage) // 구역 선택 페이지로 이동
                    }
                )
                .padding(.bottom, 20)
            }
            CTAButtonView(viewModel: viewModel)
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
                homeButtonAction: { viewModel.action(.homeButtonDidTap) },
                applyDefaultPopAction: false
            )
        )
        .onAppear {
            viewModel.action(.willAppear)
        }
    }
}
private struct TitleTextView: View {
    let seatSection: SeatSectionType
    let status: MainFeatureViewModel.UserStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(
                MainFeatureLiterals.getTitleText(seatSection: seatSection, status: status).title,
                styledSubstring: seatSection.rawValue,
                color: .scGreen,
                font: .T02_B
            )
            .font(.T02_B)
            .foregroundStyle(.gray100)
            if let subtitle = MainFeatureLiterals.getTitleText(seatSection: seatSection, status: status).subtitle {
                Text(subtitle)
                    .font(.B03_M)
                    .foregroundStyle(.gray300)
                    .underline(status != .standing)
            } else {
                Spacer()
                    .frame(height: 18)
            }
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
                    Text("다시 구역 선택하기")
                        .underline()
                }
            )
            .font(.B03_M)
            .foregroundStyle(.scGreen)
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background(.gray500)
        .clipShape(Capsule())
    }
}

private struct CTAButtonView: View {
    
    let viewModel: MainFeatureViewModel
    
    var body: some View {
        let ctaButtonTitle: String = switch viewModel.state.userStatus {
        case .seated, .standing: MainFeatureLiterals.BottomButton.manageSeat.rawValue
        case .registering, .moving, .cancelling: MainFeatureLiterals.BottomButton.confirm.rawValue
        }
        let ctaButtonStyle: CTAButton.SCButtonStyle = switch viewModel.state.userStatus {
        case .registering, .moving:
            viewModel.state.seatSectionState.selectedSeat != nil
            ? .bottomEnabled
            : .bottomDisabled
        case .seated, .standing, .cancelling: .bottomEnabled
        }
        CTAButton(
            title: ctaButtonTitle,
            action: {
                switch viewModel.state.userStatus {
                case .seated, .standing:
                    viewModel.action(.manageMySeatButtonDidTap)
                case .registering:
                    if let seat = viewModel.state.seatSectionState.selectedSeat {
                        viewModel.action(.willRegisterSeat(seat))
                    }
                case .moving:
                    if let seat = viewModel.state.seatSectionState.selectedSeat {
                        viewModel.action(.willMoveSeat(seat))
                    }
                case .cancelling:
                    viewModel.action(.willCancelSeat)
                }
            },
            style: ctaButtonStyle
        )
    }
}
