//
//  SeatInformationBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/4/25.
//

import SwiftUI

struct SeatInformationBottomSheetView: View {
    
    let profileConfig: ProfileConfig
    let station: String
    let minutesLeft: Int
    let leftButtonAction: () -> Void
    let heartFilled: Bool
    let heartCount: Int
    let rightButtonAction: () -> Void
    let coinCount: Int
    let reportAction: () -> Void
        
    var body: some View {
        SCBottomSheetBuilder()
            .withProfile(profileConfig: profileConfig)
            .withContent(
                HStack(alignment: .center, spacing: 19) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("하차")
                            .font(.B02_M)
                            .foregroundStyle(.gray300)
                        Text("하차까지")
                            .font(.B02_M)
                            .foregroundStyle(.gray300)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text(station)
                            .font(.B02_M)
                            .foregroundStyle(.gray100)
                        Text("\(minutesLeft)분 남았어요")
                            .font(.B02_M)
                            .foregroundStyle(.gray100)
                    }.padding(.trailing, 19)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 33)
            )
            .withDoubleButtonsDibsAndCoin(
                leftTitle: !heartFilled ? "찜하기" : "찜하기 취소",
                leftAction: leftButtonAction,
                heartFilled: heartFilled,
                heartCount: heartCount,
                rightTitle: "좌석요청",
                rightAction: rightButtonAction,
                coinCount: coinCount
            )
            .setReportAction(reportAction: reportAction)
            .build()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray900)
    }
}
