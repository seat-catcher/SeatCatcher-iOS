//
//  ReceiveRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

public struct ReceiveRequestBottomSheetView: View {
    
    let profileConfig: ProfileConfig
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    let coinCount: Int
    let reportAction: () -> Void
    
    public init(profileConfig: ProfileConfig, leftButtonAction: @escaping () -> Void, rightButtonAction: @escaping () -> Void, coinCount: Int, reportAction: @escaping () -> Void) {
        self.profileConfig = profileConfig
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.coinCount = coinCount
        self.reportAction = reportAction
    }
    
    public var body: some View {
        SCBottomSheetBuilder()
            .withTitle("요청을 수락할까요?",
                      subtitle: "요청을 수락하면 코인을 받을 수 있어요",
                      underlined: true)
            .withContent(
                ProfileView(profile: profileConfig)
                    .padding(12)
                    .frame(width: 190, height: 92)
                    .background(.gray850)
                    .clipShape(.rect(cornerRadius: 8))
            )
            .withDoubleButtonsCoin(
                leftTitle: "거절할래요",
                leftAction: leftButtonAction,
                rightTitle: "수락할래요",
                rightAction: rightButtonAction,
                coinCount: coinCount
            )
            .setReportAction(reportAction: reportAction)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
