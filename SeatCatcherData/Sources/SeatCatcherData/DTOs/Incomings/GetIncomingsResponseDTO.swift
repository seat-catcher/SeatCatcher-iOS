//
//  GetIncomingsResponseDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/27/25.
//

import Foundation
import SeatCatcherDomain

struct GetIncomingsResponseDTO {
    let btrainNo: String
    let ordkey: String
    let barvlDt: String
    let arvlMsg2: String
    let arvlCd: Int
    let bstatnNm: String
}

extension GetIncomingsResponseDTO: ResponseDTO {
    typealias DomainModel = Incoming

    static var stub: Self {
        .init(
            btrainNo: "1001",
            ordkey: "11002온수0",
            barvlDt: "180",
            arvlMsg2: "도착",
            arvlCd: 1,
            bstatnNm: "보라매"
        )
    }

    var domainModel: Incoming {
        let (carDirection, trainCode, destination) = parseOrdKey(ordkey)
        return Incoming(
            trainCode: trainCode,
            arrivalTime: Date().addingTimeInterval(TimeInterval(Int(barvlDt) ?? 0)),
            carDirection: carDirection,
            destination: destination
        )
    }

    private func parseOrdKey(
        _ ordkey: String
    ) -> (
        carDirection: CarDirection,
        trainCode: String,
        destination: String
    ) {
        var chars = Array(ordkey)

        let carDirection: CarDirection = String(chars[0]) == "0" ? .up : .down

        let trainCode = String(chars[2...4])

        while let last = chars.last, last.isNumber {
            chars.removeLast()
        }

        let destination = String(chars[5...])

        return (carDirection, trainCode, destination)
    }
}
