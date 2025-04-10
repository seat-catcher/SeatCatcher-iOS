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

    public init(name: String, profileImage: UserImage, tags: [UserTag], credit: Int) {
        self.name = name
        self.profileImage = profileImage
        self.tags = tags
        self.credit = credit
    }
}
