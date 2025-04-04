//
//  AskRequestDeclineBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct AskRequestDeclineBottomSheetView: View {
    
    let yesButtonAction: () -> Void
    let noButtonAction: () -> Void
    
    var body : some View {
        SCBottomSheetBuilder()
            .withTitle("좌석요청을 정말 거절하시겠어요?",
                       subtitle: "좌석요청을 수락하면 코인을 받아요\n하차역까지는 계속 앉아서 갈 수 있어요")
            .withImage(.iconReject)
            .withYesNoButtons(yesTitle: "네",
                yesAction: {
                yesButtonAction()
            },
                noTitle: "아니오",
                noAction: {
                noButtonAction()
            })
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
