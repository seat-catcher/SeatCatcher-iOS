//
//  CTAButton.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/3/25.
//

import SwiftUI

struct CTAButton: View {
    let title: String
    let action: () -> Void
    let heartFilled: Bool?
    let heartCount: Int?
    let coinCount: Int?
    let style: SCButtonStyle
    
    init(title: String, action: @escaping () -> Void, heartFilled: Bool? = nil, heartCount: Int? = nil, coinCount: Int? = nil, style: SCButtonStyle) {
        self.title = title
        self.action = action
        self.heartFilled = heartFilled
        self.heartCount = heartCount
        self.coinCount = coinCount
        self.style = style
    }
    
    enum SCButtonStyle {
        case bottomEnabled
        case bottomDisabled
        case mainLeft
        case mainRight
        case selectionYes
        case selectionNo
    }
    
    var backgroundColor: Color {
        switch style {
        case .bottomEnabled, .mainRight, .selectionYes:
            .scGreen
        case .mainLeft, .selectionNo:
            .scGreen700
        case .bottomDisabled:
            .gray500
        }
    }
    
    var textColor: Color {
        switch style {
        case .bottomEnabled, .mainRight, .selectionYes:
            .scWhite
        case .mainLeft, .selectionNo:
            .scGreen
        case .bottomDisabled:
            .gray300
        }
    }
    
    var height: CGFloat {
        switch style {
        case .bottomEnabled, .bottomDisabled, .selectionYes, .selectionNo:
            52
        case .mainLeft, .mainRight:
            87
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Text(title)
                    .font(.B01_SB)
                    .foregroundStyle(textColor)
                if let heartCount, let heartFilled {
                    HStack(spacing: 3) {
                        Image(heartFilled ? .iconHeartFilled : .iconHeartFilled)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("\(heartCount)")
                            .font(.B02_SB)
                            .foregroundStyle(.scGreen)
                    }
                }
                if let coinCount {
                    HStack(spacing: 3) {
                        Image(.iconCoin)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("\(coinCount)")
                            .font(.B02_SB)
                            .foregroundStyle(.scWhite)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
        }
        .disabled(style == .bottomDisabled)
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: 8))
    }
}
