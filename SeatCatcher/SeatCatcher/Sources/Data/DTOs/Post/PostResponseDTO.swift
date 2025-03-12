//
//  PostResponseDTO.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

struct PostResponseDTO {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// MARK: - stub 인스턴스 생성 및 DTO -> Entity 매핑
extension PostResponseDTO: ResponseDTO {
    typealias Entity = Post

    static func stub() -> Self {
        return .init(userId: 1, id: 1, title: "Stub", body: "Stub 데이터입니다.")
    }

    func toEntity() -> Post {
        return .init(id: id, title: title, content: body)
    }
}
