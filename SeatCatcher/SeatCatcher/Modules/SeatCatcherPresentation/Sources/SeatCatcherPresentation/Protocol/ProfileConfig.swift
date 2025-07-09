//
//  ProfileConfig.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/8/25.
//

import SwiftUI
import SeatCatcherDomain

public struct ProfileConfig {
    public let name: String
    public let profileImage: ImageResource
    public let tag: UserTag

    public init(name: String, profileImage: ImageResource, tag: UserTag) {
        self.name = name
        self.profileImage = profileImage
        self.tag = tag
    }
}
