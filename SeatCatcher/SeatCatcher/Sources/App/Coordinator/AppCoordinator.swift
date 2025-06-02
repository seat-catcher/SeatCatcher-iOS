//
//  AppCoordinator.swift
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

    @MainActor
    @ViewBuilder
    func buildScene(_ scene: AppScene) -> some View {
        switch scene {
        case .home:
            let store = diContainer.resolveAppStore()
            let homeViewModel = HomeViewModel(
                store: store,
                coordinator: self
            )
            HomeView(viewModel: homeViewModel)
        case .notifications:
            let notificationsViewModel = NotificationsViewModel(
                coordinator: self
            )
            NotificationsView(viewModel: notificationsViewModel)
        case .selectBoardingState:
            let selectBoardingStateViewModel = SelectBoardingStateViewModel(
                coordinator: self
            )
            SelectBoardingStateView(viewModel: selectBoardingStateViewModel)
        case .selectLine(let boardingState):
            let selectLineViewModel = SelectLineViewModel(
                boardingState: boardingState,
                coordinator: self
            )
            SelectLineView(viewModel: selectLineViewModel)
        case let .selectPath(boardingState, line):
            let selectPathViewModel = SelectPathViewModel(
                boardingState: boardingState,
                line: line,
                getPathHistoriesUseCase: diContainer.resolveGetPathHistoriesUseCase(),
                searchStationsUseCase: diContainer.resolveSearchStationsUseCase(),
                coordinator: self
            )
            SelectPathView(viewModel: selectPathViewModel)
        case .searchStations(let viewModel):
            SearchStationsView(viewModel: viewModel)
        case let .selectTrain(departure, arrival, boardingState):
            let selectTrainViewModel = SelectTrainViewModel(
                departure: departure,
                arrival: arrival,
                boardingState: boardingState,
                getIncomingsUseCase: diContainer.resolveGetIncomingsUseCase(),
                appStore: diContainer.resolveAppStore(),
                coordinator: self
            )
            SelectTrainView(viewModel: selectTrainViewModel)
        case let .inputCarCodeGuide(departure, arrival):
            let inputCarCodeGuidingViewModel = InputCarCodeGuidingViewModel(
                departure: departure,
                arrival: arrival,
                coordinator: self
            )
            InputCarCodeGuidingView(viewModel: inputCarCodeGuidingViewModel)
        case let .inputCarCode(departure, arrival):
            let inputCarCodeViewModel = InputCarCodeViewModel(
                departure: departure,
                arrival: arrival,
                appStore: diContainer.resolveAppStore(),
                startJourneyUseCase: diContainer.resolveStartJourneyUseCase(),
                subscribeArrivalTimeUseCase: diContainer.resolveSubscribeArrivalTimeUseCase(),
                coordinator: self
            )
            InputCarCodeView(viewModel: inputCarCodeViewModel)
        case .mainFeature:
            let viewModel = MainFeatureViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase(),
                getSeatInSectionUseCase: diContainer.resolveGetSeatInSectionUseCase(),
                unlockSeatUseCase: diContainer.resolveUnlockSeatUseCase()
            )
            MainFeatureView(viewModel: viewModel)
        case .mainFeatureRegisterSeat:
            let viewModel = MainFeatureViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase(),
                getSeatInSectionUseCase: diContainer.resolveGetSeatInSectionUseCase(),
                unlockSeatUseCase: diContainer.resolveUnlockSeatUseCase(),
                registerSeatUseCase: diContainer.resolveRegisterSeatUseCase()
            )
            MainFeatureView(viewModel: viewModel)
        case .mainFeatureMoveSeat:
            let viewModel = MainFeatureViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase(),
                getSeatInSectionUseCase: diContainer.resolveGetSeatInSectionUseCase(),
                unlockSeatUseCase: diContainer.resolveUnlockSeatUseCase(),
                moveSeatUseCase: diContainer.resolveMoveSeatUseCase()
            )
            MainFeatureView(viewModel: viewModel)
        case .mainFeatureCancelSeat:
            let viewModel = MainFeatureViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase(),
                getSeatInSectionUseCase: diContainer.resolveGetSeatInSectionUseCase(),
                unlockSeatUseCase: diContainer.resolveUnlockSeatUseCase(),
                cancelSeatUseCase: diContainer.resolveCancelSeatUseCase()
            )
            MainFeatureView(viewModel: viewModel)
        case .manageSeat:
            let store = diContainer.resolveAppStore()
            let viewModel = ManageSeatViewModel(
                store: store,
                coordinator: self
            )
            ManageSeatView(viewModel: viewModel)
        case .selectSeatSection:
            let viewModel = SelectSeatSectionViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase()
            )
            SelectSeatSectionView(viewModel: viewModel)
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
        switch sheet {
        case let .askRequestDeclineBottomSheetView(yesButtonAction, noButtonAction):
            AskRequestDeclineBottomSheetView(yesButtonAction: yesButtonAction, noButtonAction: noButtonAction)
        case let .askSeatChangedBottomSheetView(action):
            AskSeatChangedBottomSheetView(action: action)
        case let .askSeatedBottomSheetView(action):
            AskSeatedBottomSheetView(action: action)
        case let .changeSeatNowBottomSheetView(action):
            ChangeSeatNowBottomSheetView(action: action)
        case .dibsBottomSheetView:
            DibsBottomSheetView()
        case let .noticeChangeSeatBottomSheetView(minutesLeft):
            NoticeChangeSeatBottomSheetView(minutesLeft: minutesLeft)
        case .noticeGetOffBottomSheetView:
            NoticeGetOffBottomSheetView()
        case let .receiveRequestBottomSheetView(profileConfig, leftButtonAction, rightButtonAction, coinCount, reportAction):
            ReceiveRequestBottomSheetView(profileConfig: profileConfig, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, coinCount: coinCount, reportAction: reportAction)
        case let .rejectRequestBottomSheetView(action):
            RejectRequestBottomSheetView(action: action)
        case let .requestDeclinedBottomSheetView(action):
            RequestDeclinedBottomSheetView(action: action)
        case let .seatInformationBottomSheetView(profileConfig, station, minutesLeft, leftButtonAction, heartFilled, heartCount, rightButtonAction, coinCount, reportAction):
            SeatInformationBottomSheetView(profileConfig: profileConfig, station: station, minutesLeft: minutesLeft, leftButtonAction: leftButtonAction, heartFilled: heartFilled, heartCount: heartCount, rightButtonAction: rightButtonAction, coinCount: coinCount, reportAction: reportAction)
        case let .sendRequestBottomSheetView(profileConfig, leftButtonAction, rightButtonAction, coinCount, reportAction):
            SendRequestBottomSheetView(profileConfig: profileConfig, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, coinCount: coinCount, reportAction: reportAction)
        }
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
        switch fullScreenCover {
        case .home:
            Text("Home")
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
