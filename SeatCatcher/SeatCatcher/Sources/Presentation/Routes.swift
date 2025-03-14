//
//  Routes.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/14/25.
//

import Foundation

enum AppScene: Hashable {
    case post
    case next

    var id: String {
        switch self {
        case .post: return "post"
        case .next: return "next"
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

enum AppSheet: Hashable, Identifiable {
    case post

    var id: String {
        switch self {
        case .post: return "post"
        }
    }
}

enum AppFullScreenCover: Hashable, Identifiable {
    case post

    var id: String {
        switch self {
        case .post: return "post"
        }
    }
}
