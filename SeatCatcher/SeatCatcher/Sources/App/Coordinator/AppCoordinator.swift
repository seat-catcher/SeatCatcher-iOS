//
//  CoordinatorImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SwiftUI
import SeatCatcherCore
import SeatCatcherPresentation

@Observable
final class AppCoordinator: Coordinator {
    var diContainer: DIContainer

    var path = NavigationPath()

    var sheet: (any AppRoute)?
    var appSheet: AppSheet? {
        get { sheet as? AppSheet }
        set { sheet = newValue }
    }
    var fullScreenCover: (any AppRoute)?
    var appFullScreenCover: AppFullScreenCover? {
        get { fullScreenCover as? AppFullScreenCover }
        set { fullScreenCover = newValue }
    }

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func buildScene(_ scene: AppScene) -> some View {
        switch scene {
        case .home:
            HomeView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
        switch sheet {
        case .home:
            HomeView()
        case .askRequestDeclineBottomSheetView(yesButtonAction: let yesButtonAction, noButtonAction: let noButtonAction):
            AskRequestDeclineBottomSheetView(yesButtonAction: yesButtonAction, noButtonAction: noButtonAction)
        case .askSeatChangedBottomSheetView(action: let action):
            AskSeatChangedBottomSheetView(action: action)
        case .askSeatedBottomSheetView(action: let action):
            AskSeatedBottomSheetView(action: action)
        case .changeSeatNowBottomSheetView(action: let action):
            ChangeSeatNowBottomSheetView(action: action)
        case .dibsBottomSheetView:
            DibsBottomSheetView()
        case .noticeChangeSeatBottomSheetView(minutesLeft: let minutesLeft):
            NoticeChangeSeatBottomSheetView(minutesLeft: minutesLeft)
        case .noticeGetOffBottomSheetView:
            NoticeGetOffBottomSheetView()
        case .receiveRequestBottomSheetView(profileConfig: let profileConfig, leftButtonAction: let leftButtonAction, rightButtonAction: let rightButtonAction, coinCount: let coinCount, reportAction: let reportAction):
            ReceiveRequestBottomSheetView(profileConfig: profileConfig, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, coinCount: coinCount, reportAction: reportAction)
        case .rejectRequestBottomSheetView(action: let action):
            RejectRequestBottomSheetView(action: action)
        case .requestDeclinedBottomSheetView(action: let action):
            RequestDeclinedBottomSheetView(action: action)
        case .seatInformationBottomSheetView(profileConfig: let profileConfig, station: let station, minutesLeft: let minutesLeft, leftButtonAction: let leftButtonAction, heartFilled: let heartFilled, heartCount: let heartCount, rightButtonAction: let rightButtonAction, coinCount: let coinCount, reportAction: let reportAction):
            SeatInformationBottomSheetView(profileConfig: profileConfig, station: station, minutesLeft: minutesLeft, leftButtonAction: leftButtonAction, heartFilled: heartFilled, heartCount: heartCount, rightButtonAction: rightButtonAction, coinCount: coinCount, reportAction: reportAction)
        case .sendRequestBottomSheetView(profileConfig: let profileConfig, leftButtonAction: let leftButtonAction, rightButtonAction: let rightButtonAction, coinCount: let coinCount, reportAction: let reportAction):
            SendRequestBottomSheetView(profileConfig: profileConfig, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, coinCount: coinCount, reportAction: reportAction)
        }
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
        switch fullScreenCover {
        case .home:
            HomeView()
        }
    }
    
    @ViewBuilder
    func bottomSheetWithDimView(_ content: some View, height: CGFloat) -> some View {
        ZStack {
            Color(white: 0, opacity: 0.4)
                .zIndex(1)
                .ignoresSafeArea(.all)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(
                    .rect(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20
                    )
                )
                .ignoresSafeArea()
                .presentationDetents([.height(height)])
                .presentationBackgroundInteraction(.enabled)
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear)
                .animation(.easeInOut(duration: 0.25), value: true)
        }
    }
}
