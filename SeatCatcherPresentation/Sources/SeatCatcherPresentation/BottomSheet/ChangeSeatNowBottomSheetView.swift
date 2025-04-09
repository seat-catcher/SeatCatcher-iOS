//
//  ChangeSeatNowBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

public struct ChangeSeatNowBottomSheetView: View {
    
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
        
    public var body: some View {
        SCBottomSheetBuilder<EmptyView>()
            .withTitle("지금 자리를 바꿔주세요",
                      subtitle: "상대방이 곧 하차 예정이에요",
                      underlined: true)
            .withImage(.iconClock)
            .withCTA(title: "확인", action: action)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
