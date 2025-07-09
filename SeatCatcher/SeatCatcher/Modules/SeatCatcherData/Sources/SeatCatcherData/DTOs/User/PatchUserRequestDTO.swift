//
//  PatchUserRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/29/25.
//

struct PatchUserRequestDTO: RequestDTO {
    let name: String
    let profileImageNum: String
    let tags: [String]
    let credit: Int
    let hasOnBoarded: Bool
}
