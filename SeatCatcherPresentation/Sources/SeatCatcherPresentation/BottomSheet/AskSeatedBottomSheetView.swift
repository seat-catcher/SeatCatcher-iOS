//
//  AskSeatedBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct AskSeatedBottomSheetView: View {
    
    let action: () -> Void
    
    var body: some View {
        SCBottomSheetBuilder<EmptyView>()
            .withTitle("좌석에 앉았나요?")
            .withImage(.iconCheck)
            .withCTA(title: "좌석에 앉았어요", action: action)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
