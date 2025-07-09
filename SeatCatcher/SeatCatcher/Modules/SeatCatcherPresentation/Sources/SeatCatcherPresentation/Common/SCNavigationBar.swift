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
            backButtonAction: (() -> Void)? = nil,
            applyDefaultPopAction: Bool = true
        )
        case titleWithHomeButton(
            title: String,
            backButtonAction: (() -> Void)? = nil,
            homeButtonAction: (() -> Void)? = nil,
            applyDefaultPopAction: Bool = true
        )
        case stationSelection(
            boardingState: BoardingState,
            departureName: String?,
            arrivalName: String?,
            backButtonAction: (() -> Void)? = nil,
            swapStationsButtonAction: () -> Void,
            selectDepartureButtonAction: () -> Void,
            selectArrivalButtonAction: () -> Void,
            applyDefaultPopAction: Bool = true
        )
        case search(
            backButtonAction: (() -> Void)? = nil,
            placeholder: String,
            text: Binding<String>,
            applyDefaultPopAction: Bool = true
        )
    }
    
    init(_ coordinator: Coordinator, config: SCNavigationBarConfig) {
        self.coordinator = coordinator
        self.config = config
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch config {
                case let .skip(skipButtonAction):
                    SkipNavigationBar(skipButtonAction: skipButtonAction)
                case let .logoWithNotification(notificationButtonAction):
                    LogoWithNotificationNavigationBar(notificationButtonAction: notificationButtonAction)
                case let .title(title, backButtonAction, applyDefaultPopAction):
                    TitleNavigationBar(
                        title: title,
                        backButtonAction: backButtonAction,
                        coordinator: coordinator,
                        applyDefaultPopAction: applyDefaultPopAction
                    )
                case let .titleWithHomeButton(
                    title,
                    backButtonAction,
                    homeButtonAction,
                    applyDefaultPopAction
                ):
                    TitleWithHomeButtonNavigationBar(
                        title: title,
                        backButtonAction: backButtonAction,
                        homeButtonAction: homeButtonAction,
                        coordinator: coordinator,
                        applyDefaultPopAction: applyDefaultPopAction
                    )
                case let .stationSelection(
                    boardingState,
                    departureName,
                    arrivalName,
                    backButtonAction,
                    swapStationsButtonAction,
                    selectDepartureButtonAction,
                    selectArrivalButtonAction,
                    applyDefaultPopAction
                ):
                    StationSelectionNavigationBar(
                        boardingState: boardingState,
                        departureName: departureName,
                        arrivalName: arrivalName,
                        backButtonAction: backButtonAction,
                        swapStationsButtonAction: swapStationsButtonAction,
                        selectDepartureButtonAction: selectDepartureButtonAction,
                        selectArrivalButtonAction: selectArrivalButtonAction,
                        coordinator: coordinator,
                        applyDefaultPopAction: applyDefaultPopAction
                    )
                case let .search(
                    backButtonAction,
                    placeholder,
                    text,
                    applyDefaultPopAction
                ):
                    SearchNavigationBar(
                        backButtonAction: backButtonAction,
                        placeholder: placeholder,
                        text: text,
                        coordinator: coordinator,
                        applyDefaultPopAction: applyDefaultPopAction
                    )
                }
            }
            .padding(.horizontal, 18)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray700)
        }
        .background(.gray900)
    }
}

private struct SkipNavigationBar: View {
    let skipButtonAction: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: skipButtonAction) {
                Text("건너뛰기")
                    .underline()
                    .font(.C01_M)
                    .foregroundStyle(.gray200)
            }
        }
        .frame(height: 46)
    }
}

private struct LogoWithNotificationNavigationBar: View {
    let notificationButtonAction: () -> Void

    var body: some View {
        HStack {
            Image(.scTextLogo)
                .resizable()
                .frame(width: 140, height: 18)
            Spacer()
            Button(action: notificationButtonAction) {
                Image(.iconNotification)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .frame(height: 46)
    }
}

private struct TitleNavigationBar: View {
    let title: String
    let backButtonAction: (() -> Void)?
    let coordinator: Coordinator
    let applyDefaultPopAction: Bool

    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                Button {
                    backButtonAction?()
                    if applyDefaultPopAction {
                        coordinator.pop()
                    }
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
    }
}

private struct TitleWithHomeButtonNavigationBar: View {
    let title: String
    let backButtonAction: (() -> Void)?
    let homeButtonAction: (() -> Void)?
    let coordinator: Coordinator
    let applyDefaultPopAction: Bool

    var body: some View {
        HStack {
            Button {
                backButtonAction?()
                if applyDefaultPopAction {
                    coordinator.pop()
                }
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
                if applyDefaultPopAction {
                    coordinator.popToRoot()
                }
            }) {
                Image(.iconHome)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .frame(height: 46)
    }
}

private struct StationSelectionNavigationBar: View {
    let boardingState: BoardingState
    let departureName: String?
    let arrivalName: String?
    let backButtonAction: (() -> Void)?
    let swapStationsButtonAction: () -> Void
    let selectDepartureButtonAction: () -> Void
    let selectArrivalButtonAction: () -> Void
    let coordinator: Coordinator
    let applyDefaultPopAction: Bool

    var departurePlaceholder: String {
        if let departureName = departureName { "\(departureName)역" }
        else {
            if boardingState == .boarded { "열차의 다음 도착역 입력" }
            else { "승차역 입력" }
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button {
                backButtonAction?()
                if applyDefaultPopAction {
                    coordinator.pop()
                }
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
                            Text(departurePlaceholder)
                                .font(.B02_M)
                                .foregroundStyle(departureName == nil ? .gray300 : .gray100)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    Rectangle()
                        .fill(.gray700)
                        .frame(height: 1.6)


                    Button(action: selectArrivalButtonAction) {
                        HStack(spacing: 10) {
                            StationNodeView(.arrival)
                            Text(arrivalName == nil ? "하차역 입력" : "\(arrivalName ?? "")역")
                                .font(.B02_M)
                                .foregroundStyle(arrivalName == nil ? .gray300 : .gray100)
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
    }
}

private struct SearchNavigationBar: View {
    let backButtonAction: (() -> Void)?
    let placeholder: String
    let text: Binding<String>
    let coordinator: Coordinator
    let applyDefaultPopAction: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button {
                backButtonAction?()
                if applyDefaultPopAction {
                    coordinator.pop()
                }
            } label: {
                Image(.iconLeftArrow)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.top, 3)
            }

            TextField(placeholder, text: text, prompt: Text(placeholder).font(.B02_M).foregroundStyle(.gray300))
                .font(.B02_M)
                .foregroundStyle(.gray100)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(.gray850)
                .clipShape(.rect(cornerRadius: 12))
        }
        .frame(height: 77)
    }
}
