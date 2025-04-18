//
//  HomeView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import SwiftUI
import SeatCatcherCore
import SeatCatcherDomain

public struct HomeView: View {
    @State private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            UserInfoCardView()
            Spacer()
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .logoWithNotification(notificationButtonAction: {})
        )
    }
}

private struct UserInfoCardView: View {
    @Environment(AppStore.self) private var appStore
    var body: some View {
        Button {

        } label: {
            HStack(alignment: .center, spacing: 12) {
                Image(appStore.user.profileImage.image)
                    .resizable()
                    .frame(width: 68, height: 68)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(appStore.user.name)")
                        .font(.B01_SB)
                        .foregroundStyle(.white)
                    ScrollView(.horizontal) {
                        HStack(spacing: 6) {
                            ForEach(appStore.user.tags) {
                                UserInfoBadgeView(badgeType: .tag($0))
                            }
                            UserInfoBadgeView(badgeType: .credit(appStore.user.credit))
                        }
                    }
                    .scrollIndicators(.hidden)

                }
                VStack {
                    Image(.iconRightArrow)
                    Spacer()
                }
                .frame(height: 68)
            }
            .padding(12)
            .background(.gray850)
            .clipShape(.rect(cornerRadius: 12))
            .padding(.top, 18)
        }
    }
}

private struct UserInfoBadgeView: View {
    enum BadgeType {
        case tag(_ tag: UserTag)
        case credit(_ value: Int)
    }
    let badgeType: BadgeType

    var body: some View {
        Group {
            switch badgeType {
            case let .tag(tag):
                Text(tag.displayValue)
                    .font(.B02_SB)
                    .foregroundStyle(.scGreen)
                    .padding(.horizontal, 10)


            case let .credit(value):
                HStack(spacing: 4) {
                    Image(.iconCoin)
                        .renderingMode(.template)
                        .foregroundStyle(.scGreen)

                    Text("\(value)")
                        .font(.B02_SB)
                        .foregroundStyle(.scGreen)
                }
                .padding(.leading, 6)
                .padding(.trailing, 10)
            }
        }
        .foregroundStyle(.scGreen)
        .frame(height: 28)
        .background(.scGreen700)
        .clipShape(.rect(cornerRadius: 6))
    }
}
