//
//  MypageProfileImageChangeBottomSheetView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 7/3/25.
//

import SwiftUI
import SeatCatcherDomain

public struct MypageProfileImageChangeBottomSheetView: View {
    
    private let viewModel: MypageProfileChangeViewModel
    
    public init(viewModel: MypageProfileChangeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let imageSize = geometry.size.width * 0.23
            VStack {
                Text("프로필 이미지 선택")
                    .font(.B01_SB)
                    .foregroundStyle(.gray100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    .padding(.top, 40)
                    .padding(.bottom, 31)
                Image(viewModel.state.selectedProfileImage?.image ?? viewModel.appStore.user.profileImage.image)
                    .resizable()
                    .frame(width: 124, height: 124)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                VStack(alignment: .center) {
                    HStack(spacing: 20) {
                        ForEach([UserImage.catchy1, UserImage.catchy2, UserImage.catchy3], id: \.self) { catchy in
                            Image(catchy.image)
                                .resizable()
                                .frame(width: imageSize, height: imageSize)
                                .opacity(catchy == viewModel.state.selectedProfileImage ? 1.0 : 0.8 )
                                .onTapGesture {
                                    viewModel.action(.WillSetProfileImage(catchy))
                                }
                        }
                    }
                    .padding(.bottom, 20)
                    HStack(spacing: 20) {
                        ForEach([UserImage.coco1, UserImage.coco2, UserImage.coco3], id: \.self) { coco in
                            Image(coco.image)
                                .resizable()
                                .frame(width: imageSize, height: imageSize)
                                .opacity(coco == viewModel.state.selectedProfileImage ? 1.0 : 0.8 )
                                .onTapGesture {
                                    viewModel.action(.WillSetProfileImage(coco))
                                }
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .withBackground(.gray900)
        }
    }
}
