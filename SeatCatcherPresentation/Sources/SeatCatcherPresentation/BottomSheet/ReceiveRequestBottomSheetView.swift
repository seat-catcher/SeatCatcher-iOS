//
//  ReceiveRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct ReceiveRequestBottomSheetView: View {
    
    @Binding private var isPresented: Bool
    
    var body: some View {
        SCBottomSheetBuilder()
            .setTitle("요청을 수락할까요?",
                      subtitle: "요청을 수락하면 코인을 받을 수 있어요",
                      isSubtitleUnderlined: true)
            .setDoubleButtons(
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
