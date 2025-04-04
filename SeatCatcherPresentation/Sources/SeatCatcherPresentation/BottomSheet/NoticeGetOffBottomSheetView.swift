//
//  NoticeGetOffBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct NoticeGetOffBottomSheetView: View {
    
    @Binding private var isPresented: Bool
    
    var body: some View {
        SCBottomSheetBuilder()
            .setTitle("이제 하차하실 시간이에요")
            .setImage(.iconDoorBell)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
