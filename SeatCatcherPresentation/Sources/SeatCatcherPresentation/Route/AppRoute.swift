//
//  AppRoute.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/16/25.
//

import Foundation
import SeatCatcherCore

public enum AppScene: AppRoute {
    case home

    public var id: String {
        switch self {
        case .home: return "home"
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
