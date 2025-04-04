//
//  NoticeGetOffBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct NoticeGetOffBottomSheetView: View {
        
    var body: some View {
        SCBottomSheetBuilder()
            .withTitle("이제 하차하실 시간이에요")
            .withImage(.iconDoorBell)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
