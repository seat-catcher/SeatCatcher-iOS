//
//  SeatRequestReplyResponseDTO.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation
import SeatCatcherDomain

/// 좌석 요청자 - 응답 수신
struct SeatRequestReplyResponseDTO: Decodable {
    let ownerId: Int
    let ownerNickname: String
    let ownerProfileImageNum: String
    let isAccepted: Bool
}

extension SeatRequestReplyResponseDTO: ResponseDTO {
    
    typealias DomainModel = SeatRequestee
    
    static var stub: SeatRequestReplyResponseDTO {
        .init(
            ownerId: 0,
            ownerNickname: "날쌘 독수리",
            ownerProfileImageNum: "IMAGE_1",
            isAccepted: true // FIXME: 테스트 시 수정 필요
        )
    }
    
    var domainModel: DomainModel {
        .init(
            ownerId: ownerId,
            ownerNickname: ownerNickname,
            profileImageString: ownerProfileImageNum,
            isAccepted: isAccepted
        )
    }
}
