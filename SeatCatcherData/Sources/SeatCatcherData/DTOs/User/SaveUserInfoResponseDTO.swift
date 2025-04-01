//
//  SaveUserInfoResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/29/25.
//

struct SaveUserInfoResponseDTO {
    let status: Bool
}

extension SaveUserInfoResponseDTO: ResponseDTO {
    typealias DomainModel = Bool

    static func stub() -> Self {
        return .init(status: true)
    }

    func toDomainModel() -> Bool {
        return self.status
    }
}
