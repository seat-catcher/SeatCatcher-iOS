//
//  RequestDeclinedBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

public struct RequestDeclinedBottomSheetView: View {
    
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        SCBottomSheetBuilder<EmptyView>()
            .withTitle("좌석 요청이 거절됐어요",
                      subtitle: "다른 좌석을 도전해봐요")
            .withImage(.iconSeatWarning)
            .withCTA(title: "다른 좌석 볼래요", action: action)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
