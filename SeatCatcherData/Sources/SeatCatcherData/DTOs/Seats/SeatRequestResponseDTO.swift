//
//  SeatRequestResponseDTO.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation
import SeatCatcherDomain

/// 좌석 점유자 - 요청 수신
struct SeatRequestResponseDTO: Decodable {
    let requestUserId: Int
    let requestUserNickname: String
    let requestUserProfileImageNum: String
    let requestUserTags: [String]
    let creditAmount: Int
}

extension SeatRequestResponseDTO: ResponseDTO {
    
    typealias DomainModel = SeatRequester
    
    static var stub: Self {
        .init(
            requestUserId: 0,
            requestUserNickname: "귀여운 호랑이",
            requestUserProfileImageNum: "IMAGE_1",
            requestUserTags: ["USERTAG_LONGDISTANCE", "USERTAG_CARRIER"],
            creditAmount: 300
        )
    }
    
    var domainModel: DomainModel {
        .init(
            requesterId: requestUserId,
            requesterNickname: requestUserNickname,
            profileImage: UserImage(rawValue: requestUserProfileImageNum) ?? .catchy1,
            tags: requestUserTags.map {
                UserTag(rawValue: $0) ?? .none
            },
            creditAmount: creditAmount
        )
    }
}
