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
    case home

    public var id: String {
        switch self {
        case .home: return "home"
        }
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
