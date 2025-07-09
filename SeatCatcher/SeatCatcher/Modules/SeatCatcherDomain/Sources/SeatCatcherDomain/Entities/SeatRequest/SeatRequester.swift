//
//  SeatRequester.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석 요청자
public struct SeatRequester: Sendable {
    public var requesterId: Int
    public var requesterNickname: String
    public var profileImage: UserImage
    public var tags: [UserTag]
    public var creditAmount: Int? // 취소한 경우에는 creditAmount가 전달되지 않습니다
    
    public init(requesterId: Int, requesterNickname: String, profileImage: UserImage, tags: [UserTag], creditAmount: Int?) {
        self.requesterId = requesterId
        self.requesterNickname = requesterNickname
        self.profileImage = profileImage
        self.tags = tags
        self.creditAmount = creditAmount
    }
}
