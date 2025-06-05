//
//  MyPageView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 6/5/25.
//

import SwiftUI

public struct MyPageView: View {
    @State private var viewModel: MyPageViewModel

    public init(viewModel: MyPageViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                UserInfoArea(viewModel: viewModel)
                SettingsList(viewModel: viewModel)
            }
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .title(title: "프로필 보기")
        )
    }
}

private struct UserInfoArea: View {
    let viewModel: MyPageViewModel

    var body: some View {
        Image(viewModel.appStore.user.profileImage.image)
            .frame(width: 124, height: 124)
            .padding(.top, 18)
        Text(viewModel.appStore.user.name)
            .font(.T02_B)
            .foregroundStyle(.gray100)
            .padding(.top, 16)
            .padding(.bottom, 24)
    }
}

private struct SettingsList: View {
    let viewModel: MyPageViewModel

    var body: some View {
        ForEach(Config.allCases) {
            SettingsListCell(viewModel: viewModel, config: $0)
        }
    }
    enum Config: CaseIterable, Identifiable {
        case notification
        case customerService
        case notice
        case terms
        case logout
        case withdrawl

        var id: Self { self }

        var title: String {
            switch self {
            case .notification: "알림설정"
            case .customerService: "고객센터"
            case .notice: "공지사항"
            case .terms: "약관 및 정책"
            case .logout: "로그아웃"
            case .withdrawl: "회원탈퇴"
            }
        }

        var icon: ImageResource {
            switch self {
            case .notification: .iconNotification
            case .customerService: .iconCustomerService
            case .notice: .iconNotice
            case .terms: .iconInfo
            case .logout: .iconLogout
            case .withdrawl: .iconWithdrawl
            }
        }
    }

    struct SettingsListCell: View {
        let viewModel: MyPageViewModel
        let config: Config

        var body: some View {
            Button {
                if config == .logout { viewModel.action(.logoutButtonTapped) }
                if config == .withdrawl { viewModel.action(.withdrawalButtonTapped) }
            } label: {
                HStack(spacing: 8) {
                    Image(config.icon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray100)
                    Text(config.title)
                        .font(.B02_M)
                        .foregroundStyle(.gray100)
                    Spacer()
                    if config == .notification {
                        Toggle(
                            "",
                            isOn: Binding(
                                get: { viewModel.state.isNotificationAllowed },
                                set: { _ in viewModel.action(.toggleNotification) }
                            )
                        )
                        .tint(.scGreen)
                        .padding(.trailing, 4)
                    }
                }
                .frame(height: 45)
            }
        }
    }
}
