//
//  NotifyWaitingBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 6/5/25.
//

import Foundation
import SeatCatcherDomain
import SwiftUI

public struct NotifyWaitingBottomSheetView: View {
    let confirmationButtonAction: () -> Void

    public init(confirmationButtonAction: @escaping () -> Void) {
        self.confirmationButtonAction = confirmationButtonAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text("자리교환을 위해 요청자가 앞에서 기다려요")
                .font(.B01_SB)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
            Text("자리교환 타이밍에 맞게 푸쉬알람을 전송해요")
                .font(.SHEETSUBTITLE)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
            Image(.iconClock)
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
