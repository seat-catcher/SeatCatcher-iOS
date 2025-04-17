//
//  SCNavigationBar.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/5/25.
//

import SwiftUI
import SeatCatcherCore

struct SCNavigationBar: View {
    
    let coordinator: Coordinator
    let config: SCNavigationBarConfig
    
    enum SCNavigationBarConfig {
        case skip(
            skipButtonAction: () -> Void
        )
        case logoWithNotification(
            notificationButtonAction: () -> Void
        )
        case title(
            title: String,
            backButtonAction: (() -> Void)? = nil
        )
        case titleWithHomeButton(
            title: String,
            backButtonAction: (() -> Void)? = nil,
            homeButtonAction: (() -> Void)? = nil
        )
    }
    
    init(_ coordinator: Coordinator, config: SCNavigationBarConfig) {
        self.coordinator = coordinator
        self.config = config
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Group {
                switch config {
                case .skip(let action):
                    HStack {
                        Spacer()
                        Button(action: action) {
                            Text("건너뛰기")
                                .underline()
                                .font(.C01_M)
                                .foregroundStyle(.gray200)
                        }
                    }
                case .logoWithNotification(let action):
                    HStack {
                        Image(.scTextLogo)
                            .resizable()
                            .frame(width: 140, height: 18)
                        Spacer()
                        Button(action: action) {
                            Image(.iconNotification)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                case .title(let title, let backButtonAction):
                    ZStack(alignment: .center) {
                        HStack {
                            Button {
                                backButtonAction?()
                                coordinator.pop()
                            } label: {
                                Image(.iconLeftArrow)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            Spacer()
                        }
                        Text(title)
                            .font(.B02_SB)
                            .foregroundStyle(.gray300)
                    }
                case .titleWithHomeButton(let title, let backButtonAction, let homeButtonAction):
                    HStack {
                        Button {
                            backButtonAction?()
                            coordinator.pop()
                        } label: {
                            Image(.iconLeftArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                        Text(title)
                            .font(.B02_SB)
                            .foregroundStyle(.gray300)
                        Spacer()
                        Button(action: {
                            homeButtonAction?()
                            coordinator.popToRoot()
                        }) {
                            Image(.iconHome)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
            .padding(.horizontal, 18)

            Spacer()

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray700)
        }
        .background(.gray900)
        .frame(height: 46)
    }
}


