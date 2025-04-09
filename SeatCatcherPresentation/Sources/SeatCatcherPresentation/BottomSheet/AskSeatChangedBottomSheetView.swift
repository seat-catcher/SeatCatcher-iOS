//
//  AskSeatChangedBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

public struct AskSeatChangedBottomSheetView: View {
    
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body : some View {
        SCBottomSheetBuilder<EmptyView>()
            .withTitle("좌석을 넘기셨나요?")
            .withImage(.iconChangeSeat)
            .withCTA(title: "좌석을 넘겼어요", action: action)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
