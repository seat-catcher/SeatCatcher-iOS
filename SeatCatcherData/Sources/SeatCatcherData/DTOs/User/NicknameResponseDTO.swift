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
    typealias Entity = String

    static let randomElements = (0..<5).map { "랜덤 닉네임 \($0)" }

    static func stub() -> Self {
        return .init(nickname: randomElements.randomElement() ?? "랜덤 닉네임 0")
    }

    func toEntity() -> String {
        return self.nickname
    }
}
