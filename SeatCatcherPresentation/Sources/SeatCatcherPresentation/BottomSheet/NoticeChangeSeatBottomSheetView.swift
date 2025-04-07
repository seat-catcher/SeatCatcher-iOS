//
//  NoticeChangeSeatBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct NoticeChangeSeatBottomSheetView: View {
    
    let minutesLeft: Int
        
    var body: some View {
        SCBottomSheetBuilder()
            .withTitle("하차역에서 좌석을 넘겨주세요",
                      subtitle: "하차역에 도착하기 전까지 계속 앉을 수 있어요",
                      underlined: true)
            .withImage(.iconClock)
            .withCTA(title: "\(minutesLeft)분 남았어요", isDisabled: true)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
