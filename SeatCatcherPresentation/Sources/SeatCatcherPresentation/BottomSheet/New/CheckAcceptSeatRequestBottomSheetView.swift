//
//  CheckAcceptSeatRequestBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 6/4/25.
//

import Foundation
import SeatCatcherDomain
import SwiftUI

public struct CheckAcceptSeatRequestBottomSheetView: View {
    @State private var tagScrollViewWidth: CGFloat = .zero

    let name: String
    let userImage: UserImage
    let tags: [UserTag]
    let creditAmount: Int
    let reportButtonAction: () -> Void
    let confirmationButtonAction: () -> Void
    let cancelButtonAction: () -> Void

    public init(
        name: String,
        userImage: UserImage,
        tags: [UserTag],
        creditAmount: Int,
        reportButtonAction: @escaping () -> Void,
        confirmationButtonAction: @escaping () -> Void,
        cancelButtonAction: @escaping () -> Void
    ) {
        self.name = name
        self.userImage = userImage
        self.tags = tags
        self.creditAmount = creditAmount
        self.reportButtonAction = reportButtonAction
        self.confirmationButtonAction = confirmationButtonAction
        self.cancelButtonAction = cancelButtonAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(spacing: 6) {
                    Text("양보요청을 수락할까요?")
                        .font(.B01_SB)
                        .foregroundStyle(.gray100)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Group {
                        Text("\(creditAmount) 크레딧")
                            .font(.SHEETSUBTITLE)
                            .foregroundStyle(.scGreen)
                        +
                        Text("을 제안했어요!")
                            .font(.SHEETSUBTITLE)
                            .foregroundStyle(.gray300)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
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
            .padding(.vertical, 40)

            HStack(spacing: 6) {
                Image(userImage.image)
                    .resizable()
                    .frame(width: 68, height: 68)
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.B03_M)
                        .foregroundStyle(.gray300)
                    ScrollView(.horizontal) {
                        HStack(spacing: 6) {
                            ForEach(tags) {
                                UserInfoBadge(.tag($0))
                            }
                        }
                        .background(
                            GeometryReader { geo in Color.clear.onAppear { tagScrollViewWidth = geo.size.width } }
                        )
                    }
                    .frame(maxWidth: tagScrollViewWidth)
                }
            }
            .frame(height: 68)

            HStack(spacing: 10) {
                CTAButton(
                    title: "아니오",
                    action: cancelButtonAction,
                    style: .selectionNo
                )
                CTAButton(
                    title: "네",
                    action: confirmationButtonAction,
                    style: .selectionYes
                )
            }
            .padding(.vertical, 33)
            Spacer()
        }
        .padding(.horizontal, 18)
        .withBackground(.gray900)
    }
}


