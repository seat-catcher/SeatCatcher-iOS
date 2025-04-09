//
//  NoticeGetOffBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

public struct NoticeGetOffBottomSheetView: View {
    
    public init () {
        
    }
        
    public var body: some View {
        SCBottomSheetBuilder<EmptyView>()
            .withTitle("이제 하차하실 시간이에요")
            .withImage(.iconDoorBell)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
