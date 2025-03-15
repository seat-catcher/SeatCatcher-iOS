//
//  Routes.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/14/25.
//

import Foundation

public enum AppScene: Hashable {
    case post
    case next

    var id: String {
        switch self {
        case .post: return "post"
        case .next: return "next"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

public enum AppSheet: Hashable, Identifiable {
    case post

    public var id: String {
        switch self {
        case .post: return "post"
        }
    }
}

public enum AppFullScreenCover: Hashable, Identifiable {
    case post

    public var id: String {
        switch self {
        case .post: return "post"
        }
    }
}
