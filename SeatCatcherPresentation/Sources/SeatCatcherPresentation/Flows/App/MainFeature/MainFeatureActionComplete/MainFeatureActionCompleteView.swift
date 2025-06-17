//
//  MainFeatureActionCompleteView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 6/12/25.
//

import SwiftUI
import Lottie

public struct MainFeatureActionCompleteView: View {
    
    @State private var viewModel: MainFeatureActionCompleteViewModel
    
    public init(viewModel: MainFeatureActionCompleteViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        
        let config = viewModel.state.actionCase.config
        
        VStack(alignment: .center) {
            Group {
                if case .requestInProcess = viewModel.state.actionCase {
                    LottieView(animation: .named("InProgressLottie", bundle: .module))
                        .looping()
                } else {
                    Image(config.iconImage)
                        .resizable()
                }
            }
            .frame(width: 80, height: 80)
            .padding(.top, 221)
            .padding(.bottom, 20)
            Text(config.title)
                .multilineTextAlignment(.center)
                .font(.T01_SB)
                .foregroundStyle(.gray100)
                .padding(.top, 20)
            Text(config.subtitle)
                .multilineTextAlignment(.center)
                .underline(config.hasUnderline)
                .font(.B03_M)
                .foregroundStyle(.gray300)
                .padding(.top, 20)
            Spacer(minLength: 0)

            // FIXME: - TEMP
            TempButtonGroup(viewModel: viewModel)

            if let buttonTitle = config.buttonTitle {
                CTAButton(
                    title: buttonTitle,
                    action: {
                        viewModel.action(.willDismiss) // 버튼이 있는 경우 버튼 터치 시 dismiss
                    },
                    style:
                        buttonTitle == "확인"
                    ? .bottomEnabled // 확인
                    : .bottomMain // 요청 취소하기
                )
                .padding(.horizontal, 18)
                .padding(.bottom, 2)
            }
        }
        .applyToolbarVisibility(.hidden, for: .navigationBar)
        .withBackground(.gray900)
        .onTapGesture {
            if config.buttonTitle == nil {
                viewModel.action(.willDismiss) // 버튼이 없는 경우 터치 시 dismiss
            }
        }
        .onAppear {
            viewModel.action(.willAppear)
        }
    }
}

// FIXME: TEMP
private struct TempButtonGroup: View {
    let viewModel: MainFeatureActionCompleteViewModel

    var body: some View {
        HStack {
            Button {
                viewModel.coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .requestRejected))
            } label: {
                Color.clear
            }
            .frame(width: 20, height: 20)
            Spacer()
            Button {
                viewModel.coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .requestAccepted(stationName: "")))
            } label: {
                Color.clear
            }
            .frame(width: 20, height: 20)
        }
        .padding(.bottom, 20)
    }
}

