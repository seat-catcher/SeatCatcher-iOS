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
    case mypageProfileChange
    case mypageTermsOfService
    
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
        case .mypageProfileChange: return "mypageProfileChange"
        case .mypageTermsOfService: return "mypageTermsOfService"
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
    case checkAcceptSeatRequest(
        seatRequester: SeatRequester,
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
    case profileImageChange(
        viewModel: MypageProfileChangeViewModel
    )
    
    public var id: String {
        switch self {
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
        case .profileImageChange:
            return "profileImageChange"
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
