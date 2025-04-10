//
//  OnboardingRoute.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

public enum OnboardingScene: AppRoute {
    case login
    case onboarding
    case userInfo
    case userGreeting(_ user: User)

    public var id: String {
        switch self {
        case .login: return "login"
        case .onboarding: return "onboarding"
        case .userInfo: return "userInfo"
        case .userGreeting: return "userGreeting"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
