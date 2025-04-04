//
//  SeatInformationBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct SeatInformationBottomSheetView: View {
    
    @Binding private var isPresented: Bool
    
    var body: some View {
        SCBottomSheetBuilder()
            .setProfile(
                name: "신기한 발바닥",
                profileImage: .catchy1,
                tag: "짐꾼")
            .setDoubleButtons(
                leftTitle: "거절할래요",
                leftAction: {
                    
                },
                rightTitle: "수락할래요",
                rightAction: {
                    
                })
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
