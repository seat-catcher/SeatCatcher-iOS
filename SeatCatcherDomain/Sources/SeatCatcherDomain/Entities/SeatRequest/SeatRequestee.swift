//
//  SeatRequestee.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석 점유자
public struct SeatRequestee: Sendable {
    public var ownerId: Int
    public var ownerNickname: String
    public var profileImage: UserImage
    public var isAccepted: Bool
    
    public init(ownerId: Int, ownerNickname: String, profileImage: UserImage, isAccepted: Bool) {
        self.ownerId = ownerId
        self.ownerNickname = ownerNickname
        self.profileImage = profileImage
        self.isAccepted = isAccepted
    }
}
