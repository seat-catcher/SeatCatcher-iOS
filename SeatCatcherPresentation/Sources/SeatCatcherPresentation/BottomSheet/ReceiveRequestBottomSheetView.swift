//
//  ReceiveRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct ReceiveRequestBottomSheetView: View {
    
    let profileConfig: ProfileConfig
        
    var body: some View {
        SCBottomSheetBuilder()
            .withTitle("요청을 수락할까요?",
                      subtitle: "요청을 수락하면 코인을 받을 수 있어요",
                      underlined: true)
            .withContent(
                ProfileView(profile: profileConfig)
                    .padding(12)
                    .frame(width: 190, height: 92)
                    .background(.gray850)
                    .cornerRadius(8)
            )
            .withDoubleButtons(
                leftTitle: "거절할래요",
                leftAction: {
                    
                },
                rightTitle: "수락할래요",
                rightAction: {
                    
                })
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
