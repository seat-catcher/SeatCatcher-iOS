//
//  CancelSeatRequestResponseDTO.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation
import SeatCatcherDomain

struct CancelSeatRequestResponseDTO: Decodable {
    let requestUserId: Int
    let requestUserNickname: String
    let requestUserProfileImageNum: String
}

extension CancelSeatRequestResponseDTO: ResponseDTO {
    
    typealias DomainModel = SeatRequester
    
    static var stub: Self {
        .init(
            requestUserId: 0,
            requestUserNickname: "귀여운 호랑이",
            requestUserProfileImageNum: "IMAGE_1"
        )
    }
    
    var domainModel: DomainModel {
        .init(
            requesterId: requestUserId,
            requesterNickname: requestUserNickname,
            profileImage: UserImage(rawValue: requestUserProfileImageNum) ?? .catchy1,
            tags: [.none],
            creditAmount: nil // 요청 취소 시 크레딧 전달하지 않음
        )
    }
}

