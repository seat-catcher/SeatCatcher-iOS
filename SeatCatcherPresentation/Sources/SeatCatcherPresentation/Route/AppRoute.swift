//
//  AppRoute.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/16/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

public enum AppScene: AppRoute {
    case home
    case mypage
    case notifications
    case selectBoardingState
    case selectLine(boardingState: BoardingState)
    case selectPath(boardingState: BoardingState, line: Int)
    case searchStations(viewModel: SelectPathViewModel)
    case selectTrain(
        departure: Station,
        arrival: Station,
        boardingState: BoardingState
    )
    case inputCarCodeGuide(departure: Station, arrival: Station, incoming: Incoming)
    case inputCarCode(departure: Station, arrival: Station, incoming: Incoming)

    case mainFeature
    case mainFeatureRegisterSeat
    case mainFeatureMoveSeat
    case mainFeatureCancelSeat
    case manageSeat
    case selectSeatSection
    case unlockSeatGuide
    case mainFeatureActionComplete(actionCase: MainFeatureActionCompleteViewModel.MainFeatureActionCase)

    public var id: String {
        switch self {
        case .home: return "home"
        case .mypage: return "mypage"
        case .notifications: return "notifications"
        case .selectBoardingState: return "selectBoardingState"
        case .selectLine: return "selectLine"
        case .selectPath: return "selectPath"
        case .searchStations: return "searchStations"
        case .selectTrain: return "selectTrain"
        case .inputCarCodeGuide: return "inputCarCodeGuide"
        case .inputCarCode: return "inputCarCode"

        case .mainFeature: return "mainFeature"
        case .mainFeatureRegisterSeat: return "mainFeatureRegisterSeat"
        case .mainFeatureMoveSeat: return "mainFeatureMoveSeat"
        case .mainFeatureCancelSeat: return "mainFeatureCancelSeat"
        case .manageSeat: return "manageSeat"
        case .selectSeatSection: return "selectSeatSection"
        case .unlockSeatGuide: return "unlockSeatGuide"
        case .mainFeatureActionComplete: return "mainFeatureActionComplete"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

public enum AppSheet: AppRoute {
    // MARK: - Legacy
    case askRequestDeclineBottomSheetView(
        yesButtonAction: () -> Void,
        noButtonAction: () -> Void
    )
    case askSeatChangedBottomSheetView(
        action: () -> Void
    )
    case askSeatedBottomSheetView(
        action: () -> Void
    )
    case changeSeatNowBottomSheetView(
        action: () -> Void
    )
    case dibsBottomSheetView
    case noticeChangeSeatBottomSheetView(
        minutesLeft: Int
    )
    case noticeGetOffBottomSheetView
    case receiveRequestBottomSheetView(
        profileConfig: ProfileConfig,
        leftButtonAction: () -> Void,
        rightButtonAction: () -> Void,
        coinCount: Int,
        reportAction: () -> Void,
    )
    case rejectRequestBottomSheetView(
        action: () -> Void
    )
    case requestDeclinedBottomSheetView(
        action: () -> Void
    )
    case seatInformationBottomSheetView(
        profileConfig: ProfileConfig,
        station: String,
        minutesLeft: Int,
        leftButtonAction: () -> Void,
        heartFilled: Bool,
        heartCount: Int,
        rightButtonAction: () -> Void,
        coinCount: Int,
        reportAction: () -> Void
    )
    case sendRequestBottomSheetView(
        profileConfig: ProfileConfig,
        leftButtonAction: () -> Void,
        rightButtonAction: () -> Void,
        coinCount: Int,
        reportAction: () -> Void
    )
    // MARK: - New
    case checkAcceptSeatRequest(
        occupant: Occupant,
        creditAmount: Int,
        reportButtonAction: () -> Void,
        confirmationButtonAction: () -> Void,
        cancelButtonAction: () -> Void
    )
    case checkRejectSeatRequest(
        confirmationButtonAction: () -> Void,
        cancelButtonAction: () -> Void
    )
    case checkSeatExchange(
        confirmationButtonAction: () -> Void,
        cancelButtonAction: () -> Void
    )
    case checkSeatOccupancy(
        confirmationButtonAction: () -> Void,
        cancelButtonAction: () -> Void
    )
    case exchangeGuiding(
        confirmationButtonAction: () -> Void
    )
    case notifyWaiting(
        confirmationButtonAction: () -> Void
    )
    case requestRejected(
        confirmationButtonAction: () -> Void
    )
    case seatInfo(
        occupant: Occupant,
        reportButtonAction: () -> Void,
        yieldButtonAction: () -> Void
    )

    
    public var id: String {
        switch self {
        case .askRequestDeclineBottomSheetView:
            return "askRequestDeclineBottomSheetView"
        case .askSeatChangedBottomSheetView:
            return "askSeatChangedBottomSheetView"
        case .askSeatedBottomSheetView:
            return "askSeatedBottomSheetView"
        case .changeSeatNowBottomSheetView:
            return "changeSeatNowBottomSheetView"
        case .dibsBottomSheetView:
            return "dibsBottomSheetView"
        case .noticeChangeSeatBottomSheetView:
            return "noticeChangeSeatBottomSheetView"
        case .noticeGetOffBottomSheetView:
            return "noticeGetOffBottomSheetView"
        case .receiveRequestBottomSheetView:
            return "receiveRequestBottomSheetView"
        case .rejectRequestBottomSheetView:
            return "rejectRequestBottomSheetView"
        case .requestDeclinedBottomSheetView:
            return "requestDeclinedBottomSheetView"
        case .seatInformationBottomSheetView:
            return "seatInformationBottomSheetView"
        case .sendRequestBottomSheetView:
            return "sendRequestBottomSheetView"
        case .checkAcceptSeatRequest:
            return "checkAcceptSeatRequest"
        case .checkRejectSeatRequest:
            return "checkRejectSeatRequest"
        case .checkSeatExchange:
            return "checkSeatExchange"
        case .checkSeatOccupancy:
            return "checkSeatOccupancy"
        case .exchangeGuiding:
            return "exchangeGuiding"
        case .notifyWaiting:
            return "notifyWaiting"
        case .requestRejected:
            return "requestRejected"
        case .seatInfo:
            return "seatInfo"
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

public enum AppFullScreenCover: AppRoute {
    case home
    
    public var id: String {
        switch self {
        case .home: return "home"
        }
    }
}
