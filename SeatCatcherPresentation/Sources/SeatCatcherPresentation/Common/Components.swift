//
//  Components.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 4/19/25.
//

import SwiftUI
import SeatCatcherDomain

struct StationNodeView: View {
    enum NodeType {
        case departure
        case arrival

        var color: Color {
            switch self {
            case .departure: .gray300
            case .arrival: .scGreen
            }
        }
    }

    let nodeType: NodeType

    init(_ nodeType: NodeType) { self.nodeType = nodeType }

    var body: some View {
        Circle()
            .strokeBorder(nodeType.color, lineWidth: 2)
            .frame(width: 12, height: 12)
    }
}

struct LineNumberCircle: View {
    enum LineNumber: Int {
        case two = 2
        case seven = 7

        var color: Color {
            switch self {
            case .two: .line2
            case .seven: .line7
            }
        }
    }

    let lineNumber: LineNumber

    init(_ lineNumber: LineNumber) { self.lineNumber = lineNumber }

    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(lineNumber.color)
            Text("\(lineNumber.rawValue)")
                .font(.LINE)
                .foregroundStyle(.scWhite)
        }
        .frame(width: 16, height: 16)
    }
}

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
