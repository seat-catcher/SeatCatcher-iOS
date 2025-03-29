//
//  OnboardingRoute.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import Foundation
import SeatCatcherCore

public enum OnboardingScene: AppRoute {
    case login
    case onboarding
    case generateName
    case selectTag(_ nickname: String)

    public var id: String {
        switch self {
        case .login: return "login"
        case .onboarding: return "onboarding"
        case .generateName: return "generateName"
        case .selectTag: return "selectTag"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
