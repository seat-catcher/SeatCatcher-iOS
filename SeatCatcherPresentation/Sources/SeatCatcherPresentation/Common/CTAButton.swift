//
//  CTAButton.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/3/25.
//

import SwiftUI

struct CTAButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.B01_SB)
                .foregroundStyle(isEnabled ? .white : .gray300)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .disabled(!isEnabled)
        .background(isEnabled ? .scGreen : .gray500)
        .cornerRadius(8)
        .padding(.horizontal, 18)
    }
}
