//
//  RejectRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct RejectRequestBottomSheetView: View {
        
    var body: some View {
        SCBottomSheetBuilder()
            .withTitle("좌석요청이 거절됐어요",
                      subtitle: "좌석요청을 수락하면 코인을 받을 수 있어요")
            .withImage(.iconSend)
            .withCTA(title: "홈으로 돌아가기")
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
