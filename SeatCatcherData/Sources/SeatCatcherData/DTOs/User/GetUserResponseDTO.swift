//
//  GetUserResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 4/11/25.
//

import SeatCatcherDomain

struct GetUserResponseDTO {
    let userId: Int
    let name: String
    let profileImageNum: String
    let tags: [String]
    let credit: Int
    let hasOnBoarded: Bool
}

extension GetUserResponseDTO: ResponseDTO {
    typealias DomainModel = User

    static var stub: Self {
        .init(userId: 0, name: "Stub", profileImageNum: "Image_1", tags: ["USERTAG_NULL"], credit: 0, hasOnBoarded: true)
    }

    var domainModel: User {
        User(
            id: userId,
            name: name,
            profileImage: UserImage(rawValue: profileImageNum) ?? .catchy1,
            tags: tags.compactMap { UserTag(rawValue: $0) },
            credit: credit,
            hasOnBoarded: hasOnBoarded
        )
    }
}
