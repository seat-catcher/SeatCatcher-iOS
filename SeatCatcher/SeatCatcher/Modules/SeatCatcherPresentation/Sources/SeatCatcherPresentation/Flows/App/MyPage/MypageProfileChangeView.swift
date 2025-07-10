//
//  MypageProfileChangeView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 7/2/25.
//

import SwiftUI

public struct MypageProfileChangeView: View {
    @State private var viewModel: MypageProfileChangeViewModel

    public init(viewModel: MypageProfileChangeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                Image(viewModel.store.user.profileImage.image)
                    .frame(width: 124, height: 124)
                    .padding(.top, 18)
                ZStack {
                    Circle()
                        .foregroundStyle(.gray200)
                        .frame(width: 28, height: 28)
                    Image(.iconMove)
                        .renderingMode(.template)
                        .foregroundStyle(.gray500)
                        .frame(width: 18, height: 18)
                }
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 4)
                )
            }
            .onTapGesture {
                viewModel.action(.didTapprofileimageChangeButton)
            }
            .padding(.top, 18)
            .padding(.bottom, 32)
            HStack(alignment: .center, spacing: 8) {
                Text(viewModel.store.user.name)
                    .font(.T03_SB)
                    .foregroundStyle(viewModel.state.didChangeNickname ? .gray100 : .gray300)
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.gray700)
                    .clipShape(.rect(cornerRadius: 12))
                Button(
                    action: {
                        viewModel.action(.willSetNewNickname)
                    },
                    label: {
                        ZStack {
                            Image(.iconChangeArrow)
                        }
                        .frame(width: 44, height: 44)
                        .background(.scGreen)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                )
            }
            .padding(.leading, 18)
            .padding(.trailing, 16)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .title(title: "프로필 변경")
        )
    }
}
