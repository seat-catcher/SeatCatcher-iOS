//
//  SCNavigationBar.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/5/25.
//

import SwiftUI

struct SCNavigationBar: View {
    
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
            backButtonAction: () -> Void
        )
        case titleWithHomeButton(
            title: String,
            backButtonAction: () -> Void,
            homeButtonAction: () -> Void
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
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
                .padding(.horizontal, 18)
                .padding(.bottom, 21)
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
                .padding(.horizontal, 18)
                .padding(.bottom, 10)
            case .title(let title, let action):
                ZStack(alignment: .center) {
                    HStack {
                        Button(action: action) {
                            Image(.iconLeftArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    Text(title)
                        .font(.B02_SB)
                        .foregroundStyle(.gray300)
                }.padding(.bottom, 10)
            case .titleWithHomeButton(let title, let backButtonAction, let homeButtonAction):
                HStack {
                    Button(action: backButtonAction) {
                        Image(.iconLeftArrow)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Spacer()
                    Text(title)
                        .font(.B02_SB)
                        .foregroundStyle(.gray300)
                    Spacer()
                    Button(action: homeButtonAction) {
                        Image(.iconHome)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 18)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray700)
        }
        .frame(height: 90)
        .background(.gray900)
        .ignoresSafeArea()
    }
}


