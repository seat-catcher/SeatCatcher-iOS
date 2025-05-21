//
//  UserInfoBadge.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/22/25.
//

import SwiftUI
import SeatCatcherDomain

struct UserInfoBadge: View {
    enum BadgeType {
        case tag(_ tag: UserTag)
        case credit(_ value: Int)
    }

    let badgeType: BadgeType

    init(_ badgeType: BadgeType) { self.badgeType = badgeType }

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
