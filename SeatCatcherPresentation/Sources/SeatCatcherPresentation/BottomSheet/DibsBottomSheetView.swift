//
//  DibsBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct DibsBottomSheetView: View {
    
    @Binding private var isPresented: Bool
    
    var body: some View {
        SCBottomSheetBuilder()
            .setTitle("좌석을 찜했어요",
                      subtitle: "좌석요청을 통해 찜한 좌석에 앉아보세요")
            .setImage(.iconSeatHeart)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
