//
//  RejectRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct RejectRequestBottomSheetView: View {
    
    @Binding private var isPresented: Bool
    
    var body: some View {
        SCBottomSheetBuilder()
            .setTitle("좌석요청이 거절됐어요",
                      subtitle: "좌석요청을 수락하면 코인을 받을 수 있어요")
            .setImage(.iconSend)
            .setCTAButton(
                title: "홈으로 돌아가기",
                action: {
                
            })
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
