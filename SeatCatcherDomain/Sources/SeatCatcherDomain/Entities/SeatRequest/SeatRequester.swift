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
    public var profileImageString: String
    public var userTag: [UserTag]
    public var creditAmount: Int? // 취소한 경우에는 creditAmount가 전달되지 않습니다
    
    public init(requesterId: Int, requesterNickname: String, profileImageString: String, userTag: [UserTag], creditAmount: Int?) {
        self.requesterId = requesterId
        self.requesterNickname = requesterNickname
        self.profileImageString = profileImageString
        self.userTag = userTag
        self.creditAmount = creditAmount
    }
}
