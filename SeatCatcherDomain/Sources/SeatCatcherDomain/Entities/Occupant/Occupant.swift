//
//  Occupant.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/27/25.
//

import Foundation

public struct Occupant: Sendable {
    public var id: Int // 유저 id(서버)
    public var name: String // 닉네임
    public var profileImage: UserImage // 프로필 사진
    public var tags: [UserTag] // 태그
    public var minutesLeftToGetOff: Int // 하차까지 남은 시간(분)
    public var stationToGetOff: String // 하차역
    
    public init(id: Int, name: String, profileImage: UserImage, tags: [UserTag], minutesLeftToGetOff: Int, stationToGetOff: String) {
        self.id = id
        self.name = name
        self.profileImage = profileImage
        self.tags = tags
        self.minutesLeftToGetOff = minutesLeftToGetOff
        self.stationToGetOff = stationToGetOff
    }
}
