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
        case stationSelection(
            backButtonAction: (() -> Void)?,
            swapStationsButtonAction: () -> Void,
            selectDepartureButtonAction: () -> Void,
            selectArrivalButtonAction: () -> Void
        )
        case search(
            backButtonAction: (() -> Void)?,
            placeholder: String,
            text: Binding<String>
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
                    .frame(height: 46)
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
                    .frame(height: 46)
                case let .title(title, backButtonAction):
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
                    .frame(height: 46)
                case let .titleWithHomeButton(title, backButtonAction, homeButtonAction):
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
                    .frame(height: 46)

                case let .stationSelection(
                    backButtonAction,
                    swapStationsButtonAction,
                    selectDepartureButtonAction,
                    selectArrivalButtonAction
                ):
                    HStack(alignment: .top, spacing: 8) {

                        Button {
                            backButtonAction?()
                            coordinator.pop()
                        } label: {
                            Image(.iconLeftArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.top, 3)


                        HStack(spacing: 10) {
                            Button(action: swapStationsButtonAction) { Image(.iconSwapStations) }

                            VStack(spacing: 10) {
                                Button(action: selectDepartureButtonAction) {
                                    HStack(spacing: 10) {
                                        StationNodeView(.departure)
                                        Text("승차역 입력")
                                            .font(.B02_M)
                                            .foregroundStyle(.gray300)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }

                                Rectangle()
                                    .fill(.gray700)
                                    .frame(height: 1.6)


                                Button(action: selectArrivalButtonAction) {
                                    HStack(spacing: 10) {
                                        StationNodeView(.arrival)
                                        Text("하차역 입력")
                                            .font(.B02_M)
                                            .foregroundStyle(.gray300)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .background(.gray850)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .frame(height: 118)

                case let .search(backButtonAction, placeholder, text):
                    HStack(alignment: .top, spacing: 8) {
                        Button {
                            backButtonAction?()
                        } label: {
                            Image(.iconLeftArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.top, 3)
                        }
                        TextField(placeholder, text: text)
                            .font(.B02_M)
                            .foregroundStyle(.gray300)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(.gray850)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    .frame(height: 77)
                }
            }
            .padding(.horizontal, 18)

            Spacer()

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray700)
        }
        .background(.gray900)
    }
}
