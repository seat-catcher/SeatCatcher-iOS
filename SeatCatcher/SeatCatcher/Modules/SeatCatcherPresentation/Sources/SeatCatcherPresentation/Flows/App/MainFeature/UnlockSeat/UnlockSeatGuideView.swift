//
//  UnlockSeatGuideView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 6/12/25.
//

import SwiftUI
import SeatCatcherCore

public struct UnlockSeatGuideView: View {
    
    @State private var viewModel: UnlockSeatGuideViewModel
    
    public init(viewModel: UnlockSeatGuideViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack {
                HStack(alignment: .center, spacing: 4) {
                    Image(.catchy1)
                        .resizable()
                        .frame(width: 68, height: 68)
                    VStack(alignment: .leading, spacing: 7) {
                        Group {
                            Text("신기한 발바닥")
                                .font(.B03_M)
                                .foregroundStyle(.gray300)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack(alignment: .center, spacing: 0) {
                                Text("짐꾼")
                                    .font(.B03_SB)
                                    .foregroundStyle(.scGreen)
                                    .padding(.horizontal, 10)
                                    .frame(height: 28)
                                    .background(.gray700)
                                    .clipShape(.rect(cornerRadius: 6))
                                    .padding(.trailing, 4)
                                Text("장거리 이용객")
                                    .font(.B03_SB)
                                    .foregroundStyle(.scGreen)
                                    .padding(.horizontal, 10)
                                    .frame(height: 28)
                                    .background(.gray700)
                                    .clipShape(.rect(cornerRadius: 6))
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                HStack(alignment: .center, spacing: 6) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("하차")
                            .font(.B02_M)
                            .foregroundStyle(.gray300)
                        Text("하차까지")
                            .font(.B02_M)
                            .foregroundStyle(.gray300)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("상도역")
                            .font(.B02_M)
                            .foregroundStyle(.gray100)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("30분 남았어요")
                            .font(.B02_M)
                            .foregroundStyle(.gray100)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.leading, 20)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .frame(width: 270, height: 200)
            .background(.gray800)
            .opacity(0.7)
            .clipShape(.rect(cornerRadius: 30))
            .padding(.top, 147)
            Text("좌석정보 열람하고\n편안한 이동하기")
                .multilineTextAlignment(.center)
                .font(.T02_B)
                .foregroundStyle(.gray100)
                .padding(.top, 46)
            Text("단 10 크레딧이면 빨리\n비워질 좌석을 확인할 수 있어요")
                .multilineTextAlignment(.center)
                .font(.B03_M)
                .foregroundStyle(.gray300)
                .padding(.top, 20)
            Spacer(minLength: 0)
            CTAButton(
                title: "좌석정보 열람하기",
                action: {
                    viewModel.action(.unlockSeat)
                },
                style: .bottomEnabled
            ).padding(.bottom, 11)
            CTAButton(
                title: "돌아가기",
                action: {
                    viewModel.action(.willDismiss)
                },
                style: .bottomMain
            )
            .padding(.bottom, 36)
        }
        .applyToolbarVisibility(.hidden, for: .navigationBar)
        .padding(.horizontal, 18)
        .ignoresSafeArea(edges: .bottom)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.gray900, .grayGradient]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
