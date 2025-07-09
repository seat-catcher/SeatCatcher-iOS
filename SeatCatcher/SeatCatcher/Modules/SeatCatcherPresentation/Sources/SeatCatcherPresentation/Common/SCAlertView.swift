//
//  SCAlertView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/6/25.
//

import SwiftUI

struct SCAlertView: View {

    let title: String
    let subtitle: String
    let buttonTitle: String
    let buttonAction: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 16) {
                Text(title)
                    .font(.B02_B)
                    .foregroundStyle(.gray100)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(.B02_M)
                    .foregroundStyle(.gray100)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 26)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray400)
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(.B02_B)
                    .foregroundStyle(.scGreen)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 266)
        .background(.gray500)
        .clipShape(.rect(cornerRadius: 20))
    }
}
