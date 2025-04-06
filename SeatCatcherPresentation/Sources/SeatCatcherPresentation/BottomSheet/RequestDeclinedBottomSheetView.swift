//
//  RequestDeclinedBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct RequestDeclinedBottomSheetView: View {
    
    let action: () -> Void
    
    var body: some View {
        SCBottomSheetBuilder()
            .withTitle("좌석 요청이 거절됐어요",
                      subtitle: "다른 좌석을 도전해봐요")
            .withImage(.iconSeatWarning)
            .withCTA(title: "다른 좌석 볼래요", action: action)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
