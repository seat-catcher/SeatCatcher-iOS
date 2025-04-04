//
//  AskSeatChangedBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct AskSeatChangedBottomSheetView: View {
    
    let ctaButtonAction: () -> Void
    
    var body : some View {
        SCBottomSheetBuilder()
            .withTitle("좌석을 넘기셨나요?")
            .withImage(.iconChangeSeat)
            .withCTA(title: "좌석을 넘겼어요",
                action: {
                ctaButtonAction()
            })
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
