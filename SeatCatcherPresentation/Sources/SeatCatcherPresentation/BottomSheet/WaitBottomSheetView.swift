//
//  WaitBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct WaitBottomSheetView: View {
    
    let minutesLeft: Int
        
    var body: some View {
        SCBottomSheetBuilder()
            .withTitle("잠시 서서 기다려주세요",
                      subtitle: "좌석수락자 하차역에 도착하기 전까지 앉을 수 있어요",
                      underlined: true)
            .withImage(.iconClock)
            .withCTA(title: "\(minutesLeft)분 남았어요")
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
