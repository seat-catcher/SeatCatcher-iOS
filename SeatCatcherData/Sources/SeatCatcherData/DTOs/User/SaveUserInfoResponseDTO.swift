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

    static var stub: Self { .init(status: true) }

    var domainModel: Bool { self.status }
}
