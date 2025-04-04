//
//  SendRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct SendRequestBottomSheetView: View {
    
    let profileConfig: ProfileConfig
    
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
                    .cornerRadius(8)
            )
            .withDoubleButtons(
                leftTitle: "찜하기",
                leftAction: {
                    
                },
                rightTitle: "앉을래요",
                rightAction: {
                    
                })
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
