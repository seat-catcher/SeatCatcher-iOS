//
//  SendRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct SendRequestBottomSheetView: View {
    
    let profileConfig: ProfileConfig
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    let coinCount: Int
    let reportAction: () -> Void
    
    var body: some View {
        SCBottomSheetBuilder()
            .withTitle("좌석요청을 할까요?",
                       subtitle: "요청 수락과 관계없이 코인은 소모됩니다.",
                       underlined: true)
            .withContent(
                ProfileView(profile: profileConfig)
                    .padding(12)
                    .frame(width: 190, height: 92)
                    .background(.gray850)
                    .clipShape(.rect(cornerRadius: 8))
            )
            .withDoubleButtonsCoin(
                leftTitle: "돌아갈래요",
                leftAction: leftButtonAction,
                rightTitle: "앉을래요",
                rightAction: rightButtonAction,
                coinCount: coinCount
            )
            .setReportAction(reportAction: reportAction)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
