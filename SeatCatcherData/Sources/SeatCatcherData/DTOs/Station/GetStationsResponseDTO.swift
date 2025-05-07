//
//  GetStationsResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/7/25.
//

import SeatCatcherDomain

struct GetStationsResponseDTO {
    let id: Int
    let name: String
    let line: String
    let timeMinSec: String
    let acmlTime: Int
    let distKm: Double
    let acmlDist: Double
}

extension GetStationsResponseDTO: ResponseDTO {
    typealias DomainModel = Station

    static var stub: GetStationsResponseDTO {
        .init(
            id: 1, name: "stub", line: "2", timeMinSec: "1:30",
            acmlTime: 3240, distKm: 1.1, acmlDist: 40.8
        )
    }

    var domainModel: Station { .init(id: id, name: name, line: Int(line) ?? 2) }
}
