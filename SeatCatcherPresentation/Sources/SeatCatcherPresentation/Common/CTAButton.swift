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
    let style: SCButtonStyle
    
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
            Text(title)
                .font(.B01_SB)
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: height)
        }
        .disabled(style == .bottomDisabled)
        .background(backgroundColor)
        .cornerRadius(8)
    }
}
