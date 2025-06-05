//
//  CheckRejectSeatRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 6/5/25.
//

import Foundation
import SeatCatcherDomain
import SwiftUI

public struct CheckRejectSeatRequestBottomSheetView: View {
    let confirmationButtonAction: () -> Void
    let cancelButtonAction: () -> Void

    public init(confirmationButtonAction: @escaping () -> Void, cancelButtonAction: @escaping () -> Void) {
        self.confirmationButtonAction = confirmationButtonAction
        self.cancelButtonAction = cancelButtonAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text("양보요청을 정말 거절하시겠어요?")
                .font(.B01_SB)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
            Text("양보요청을 수락하시면 원하는 만큼 크레딧을 받아요")
                .font(.SHEETSUBTITLE)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
            Image(.iconReject)
                .padding(.vertical, 26)
            HStack(spacing: 10) {
                CTAButton(
                    title: "아니오",
                    action: cancelButtonAction,
                    style: .selectionNo
                )
                CTAButton(
                    title: "네",
                    action: confirmationButtonAction,
                    style: .selectionYes
                )
            }
            Spacer()
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
    }
}
