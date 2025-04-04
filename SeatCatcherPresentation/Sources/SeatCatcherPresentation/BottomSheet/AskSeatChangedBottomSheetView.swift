//
//  AskSeatChangedBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct AskSeatChangedBottomSheetView: View {
    
    @Binding private var isPresented : Bool
    
    var body : some View {
        SCBottomSheetBuilder()
            .setTitle("좌석을 넘기셨나요?")
            .setImage(.iconChangeSeat)
            .setCTAButton(
                title: "좌석을 넘겼어요",
                action: {
                    
            })
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
