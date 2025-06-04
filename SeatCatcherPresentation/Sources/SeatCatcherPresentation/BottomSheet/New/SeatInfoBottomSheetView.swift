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
    let name: String
    let userImage: UserImage
    let tags: [UserTag]
    let arrivalStationName: String
    let expectedArrivalTime: Date
    let reportButtonAction: () -> Void
    let yieldButtonAction: () -> Void

    var remainingMinutes: Int {
        Int(expectedArrivalTime.timeIntervalSinceNow / 60)
    }

    public init(
        name: String,
        userImage: UserImage,
        tags: [UserTag],
        arrivalStationName: String,
        expectedArrivalTime: Date,
        reportButtonAction: @escaping () -> Void,
        yieldButtonAction: @escaping () -> Void
    ) {
        self.name = name
        self.userImage = userImage
        self.tags = tags
        self.arrivalStationName = arrivalStationName
        self.expectedArrivalTime = expectedArrivalTime
        self.reportButtonAction = reportButtonAction
        self.yieldButtonAction = yieldButtonAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(userImage.image)
                    .resizable()
                    .frame(width: 68, height: 68)
                VStack(spacing: 6) {
                    Text(name)
                        .font(.B03_M)
                        .foregroundStyle(.gray300)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal) {
                        HStack(spacing: 6) {
                            ForEach(tags) {
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
                        Text("\(arrivalStationName)역")
                        Text("\(remainingMinutes)분 남았어요")
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
