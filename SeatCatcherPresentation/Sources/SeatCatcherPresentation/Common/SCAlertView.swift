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
            Text(title)
                .font(.B02_B)
                .foregroundStyle(.gray100)
                .padding(.top, 26)
            Text(subtitle)
                .font(.B02_M)
                .foregroundStyle(.gray100)
                .padding(.top, 16)
                .multilineTextAlignment(.center)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray400)
                .padding(.top, 25)
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(.B02_B)
                    .foregroundStyle(.scGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 47)
                    .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity)
        }
        .background(.gray500)
        .frame(width: 266)
        .frame(minHeight: 178)
        .clipShape(.rect(cornerRadius: 20))
    }
}
