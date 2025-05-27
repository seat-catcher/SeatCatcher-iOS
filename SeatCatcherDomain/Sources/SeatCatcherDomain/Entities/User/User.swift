//
//  User.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/11/25.
//

import Foundation

public struct User: Sendable {
    public var name: String
    public var profileImage: UserImage
    public var tags: [UserTag]
    public var credit: Int
    public var hasOnBoarded: Bool

    public init(name: String, profileImage: UserImage, tags: [UserTag], credit: Int, hasOnBoarded: Bool) {
        self.name = name
        self.profileImage = profileImage
        self.tags = tags
        self.credit = credit
        self.hasOnBoarded = hasOnBoarded
    }

    public init(hasOnBoarded: Bool) {
        self.name = ""
        self.profileImage = .catchy1
        self.tags = []
        self.credit = 0
        self.hasOnBoarded = hasOnBoarded
    }
}
