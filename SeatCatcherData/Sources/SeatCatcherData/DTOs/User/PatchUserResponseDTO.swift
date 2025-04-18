//
//  PatchUserResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/29/25.
//

import SeatCatcherDomain

struct PatchUserResponseDTO {
    let name: String
    let profileImageNum: String
    let tags: [String]
    let credit: Int
    let hasOnBoarded: Bool
}

extension PatchUserResponseDTO: ResponseDTO {
    typealias DomainModel = User

    static var stub: Self { .init(name: "Stub", profileImageNum: "Image_1", tags: ["USERTAG_NULL"], credit: 0, hasOnBoarded: true) }

    var domainModel: User {
        User(
            name: name,
            profileImage: UserImage(rawValue: profileImageNum) ?? .catchy1,
            tags: tags.compactMap { UserTag(rawValue: $0) },
            credit: credit,
            hasOnBoarded: hasOnBoarded
        )
    }
}
