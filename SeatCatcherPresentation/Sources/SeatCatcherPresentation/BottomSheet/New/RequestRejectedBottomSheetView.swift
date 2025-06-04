//
//  RequestRejectedBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 6/5/25.
//

import Foundation
import SeatCatcherDomain
import SwiftUI

public struct RequestRejectedBottomSheetView: View {
    let confirmationButtonAction: () -> Void

    public init(confirmationButtonAction: @escaping () -> Void) {
        self.confirmationButtonAction = confirmationButtonAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text("양보요청이 거절됐어요")
                .font(.B01_SB)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
            Text("양보요청을 수락하시면 원하는 만큼 크레딧을 받아요")
                .font(.SHEETSUBTITLE)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
            Image(.iconSend)
                .padding(.vertical, 26)
            CTAButton(
                title: "확인",
                action: confirmationButtonAction,
                style: .bottomEnabled
            )
            Spacer()
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
    }
}
