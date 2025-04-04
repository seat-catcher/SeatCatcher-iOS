//
//  WaitBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct WaitBottomSheetView: View {
    
    @Binding private var isPresented: Bool
    
    var body: some View {
        SCBottomSheetBuilder()
            .setTitle("잠시 서서 기다려주세요",
                      subtitle: "좌석수락자 하차역에 도착하기 전까지 앉을 수 있어요",
                      isSubtitleUnderlined: true)
            .setImage(.iconClock)
            .setCTAButton(
                title: "NN분 남았어요",
                action: nil)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
