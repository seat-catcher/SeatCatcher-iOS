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
                getPathHistoriesUseCase: diContainer.resolveGetPathHistoriesUseCase(),
                getStationUseCase: diContainer.resolveGetStationUseCase(),
                getIncomingsUseCase: diContainer.resolveGetIncomingsUseCase(),
                coordinator: self
            )
            HomeView(viewModel: homeViewModel)
        case .mypage:
            let mypageViewModel = MyPageViewModel(
                store: diContainer.resolveAppStore(),
                logoutUseCase: diContainer.resolveLogoutUseCase(),
                withdrawUseCase: diContainer.resolveWithdrawUseCase(),
                coordinator: self
            )
            MyPageView(viewModel: mypageViewModel)
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
                store: diContainer.resolveAppStore(),
                coordinator: self
            )
            SelectTrainView(viewModel: selectTrainViewModel)
        case let .inputCarCodeGuide(departure, arrival, incoming):
            let inputCarCodeGuidingViewModel = InputCarCodeGuidingViewModel(
                departure: departure,
                arrival: arrival,
                incoming: incoming,
                coordinator: self
            )
            InputCarCodeGuidingView(viewModel: inputCarCodeGuidingViewModel)
        case let .inputCarCode(departure, arrival, incoming):
            let inputCarCodeViewModel = InputCarCodeViewModel(
                departure: departure,
                arrival: arrival,
                incoming: incoming,
                store: diContainer.resolveAppStore(),
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
                subscribeTrainUseCase: diContainer.resolveSubscribeTrainUseCase(),
                cancelSeatRequestUseCase: diContainer.resolveCancelRequestSeatUseCase(),
                acceptSeatRequestUseCase: diContainer.resolveAcceptRequestSeatUseCase(),
                rejectSeatRequestUseCase: diContainer.resolveRejectRequestSeatUseCase()
            )
            MainFeatureView(viewModel: viewModel)
        case .mainFeatureRegisterSeat:
            let viewModel = MainFeatureViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase(),
                getSeatInSectionUseCase: diContainer.resolveGetSeatInSectionUseCase(),
                registerSeatUseCase: diContainer.resolveRegisterSeatUseCase()
            )
            MainFeatureView(viewModel: viewModel)
        case .mainFeatureMoveSeat:
            let viewModel = MainFeatureViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase(),
                getSeatInSectionUseCase: diContainer.resolveGetSeatInSectionUseCase(),
                moveSeatUseCase: diContainer.resolveMoveSeatUseCase()
            )
            MainFeatureView(viewModel: viewModel)
        case .mainFeatureCancelSeat:
            let viewModel = MainFeatureViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getSeatInTrainCarUseCase: diContainer.resolveGetSeatInTrainCarUseCase(),
                getSeatInSectionUseCase: diContainer.resolveGetSeatInSectionUseCase(),
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
        case .unlockSeatGuide:
            let viewModel = UnlockSeatGuideViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                unlockSeatUseCase: diContainer.resolveUnlockSeatUseCase()
            )
            UnlockSeatGuideView(viewModel: viewModel)
        case let .mainFeatureActionComplete(actionCase):
            let viewModel = MainFeatureActionCompleteViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                actionCase: actionCase,
                receiveSeatUseCase: diContainer.resolveReceiveSeatUseCase(),
                cancelRequestSeatUseCase: diContainer.resolveCancelRequestSeatUseCase()
            )
            MainFeatureActionCompleteView(viewModel: viewModel)
        case let .inputCredit(stationName, seat):
            let viewModel = InputCreditViewModel(
                stationName: stationName,
                seat: seat,
                requestSeatUseCase: diContainer.resolveRequestSeatUseCase(),
                store: diContainer.resolveAppStore(),
                coordinator: self
            )
            InputCreditView(viewModel: viewModel)
        case .mypageProfileChange:
            let viewModel = MypageProfileChangeViewModel(
                store: diContainer.resolveAppStore(),
                coordinator: self,
                getRandomNicknameUseCase: diContainer.resolveGetRandomNicknameUseCase(),
                patchUserInfoUseCase: diContainer.resolvePatchUserInfoUseCase()
            )
            MypageProfileChangeView(viewModel: viewModel)
        case .mypageTermsOfService:
            MypageTermsofServiceView(coordinator: self)
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
        Group {
            switch sheet {
            case let .checkAcceptSeatRequest(
                seatRequester,
                reportButtonAction,
                confirmationButtonAction,
                cancelButtonAction
            ):
                CheckAcceptSeatRequestBottomSheetView(
                    seatRequester: seatRequester,
                    reportButtonAction: reportButtonAction,
                    confirmationButtonAction: confirmationButtonAction,
                    cancelButtonAction: cancelButtonAction
                )
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])

            case let .checkRejectSeatRequest(confirmationButtonAction, cancelButtonAction):
                CheckRejectSeatRequestBottomSheetView(
                    confirmationButtonAction: confirmationButtonAction,
                    cancelButtonAction: cancelButtonAction
                )
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])

            case let .checkSeatOccupancy(confirmationButtonAction, cancelButtonAction):
                CheckSeatOccupancyStatusBottomSheetView(
                    confirmationButtonAction: confirmationButtonAction,
                    cancelButtonAction: cancelButtonAction
                )
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])

            case let .verifyRequest(confirmationButtonAction):
                VerifyRequestBottomSheetView(confirmationButtonAction: confirmationButtonAction)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])

            case let .requestRejected(confirmationButtonAction):
                RequestRejectedBottomSheetView(confirmationButtonAction: confirmationButtonAction)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])

            case let .seatInfo(
                occupant,
                reportButtonAction,
                yieldButtonAction
            ):
                SeatInfoBottomSheetView(
                    occupant: occupant,
                    reportButtonAction: reportButtonAction,
                    yieldButtonAction: yieldButtonAction
                )
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])

            case let .profileImageChange(viewModel):
                MypageProfileImageChangeBottomSheetView(viewModel: viewModel)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(507)])
            }
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
