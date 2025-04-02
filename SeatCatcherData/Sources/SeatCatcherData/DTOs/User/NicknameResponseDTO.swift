//
//  NicknameResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/29/25.
//

struct NicknameResponseDTO {
    let nickname: String
}

extension NicknameResponseDTO: ResponseDTO {
    typealias DomainModel = String

    static let randomElements = (0..<5).map { "랜덤 닉네임 \($0)" }

    static var stub: Self { .init(nickname: randomElements.randomElement() ?? "랜덤 닉네임 0") }

    var domainModel: String { self.nickname }
}
