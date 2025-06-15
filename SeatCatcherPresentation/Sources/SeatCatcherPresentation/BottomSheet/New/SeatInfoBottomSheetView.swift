//
//  SeatInfoBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 6/4/25.
//

import Foundation
import SeatCatcherDomain
import SwiftUI

public struct SeatInfoBottomSheetView: View {
    let occupant: Occupant
    let reportButtonAction: () -> Void
    let yieldButtonAction: () -> Void

    public init(
        occupant: Occupant,
        reportButtonAction: @escaping () -> Void,
        yieldButtonAction: @escaping () -> Void
    ) {
        self.occupant = occupant
        self.reportButtonAction = reportButtonAction
        self.yieldButtonAction = yieldButtonAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(occupant.profileImage.image)
                    .resizable()
                    .frame(width: 68, height: 68)
                VStack(spacing: 6) {
                    Text(occupant.name)
                        .font(.B03_M)
                        .foregroundStyle(.gray300)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal) {
                        HStack(spacing: 6) {
                            ForEach(occupant.tags) {
                                UserInfoBadge(.tag($0))
                            }
                        }
                    }
                }
                Button(action: reportButtonAction) {
                    HStack(spacing: 0) {
                        Image(.iconAlarm)
                        Text("신고하기")
                            .font(.C01_M)
                            .foregroundStyle(.gray300)
                    }
                    .padding(6)
                    .background(.gray500)
                    .clipShape(.rect(cornerRadius: 6))
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .frame(height: 68)
            .padding(.vertical, 40)

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        Text("하차")
                        Text("하차까지")
                    }
                    .font(.B02_M)
                    .foregroundStyle(.gray300)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        Text("\(occupant.stationToGetOff)역")
                        Text("\(occupant.minutesLeftToGetOff)분 남았어요")
                    }
                    .font(.B02_M)
                    .foregroundStyle(.gray100)
                }
                Spacer()
            }

            CTAButton(
                title: "양보 요청하기",
                action: yieldButtonAction,
                style: .bottomEnabled
            )
            .padding(.vertical, 33)
            Spacer()
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
    }
}
