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
        let (trainCode, destination) = parseOrdKey(ordkey)
        dump(trainCode)
        dump(destination)
        let arrivalTime = getFormattedArrivalTime(barvlDt: barvlDt)
        return Incoming(
            trainCode: trainCode,
            arrivalTime: arrivalTime,
            destination: destination
        )
    }

    private func parseOrdKey(_ ordkey: String) -> (String, String) {
        var chars = Array(ordkey)

        let trainCode = String(chars[2...4])

        while let last = chars.last, last.isNumber {
            chars.removeLast()
        }

        let destination = String(chars[5...])

        return (trainCode, destination)
    }

    private func getFormattedArrivalTime(barvlDt: String) -> String {
        let seconds = Int(barvlDt) ?? 180
        let baseDate = Date()

        let arrivalDate = baseDate.addingTimeInterval(TimeInterval(seconds))

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"

        return formatter.string(from: arrivalDate)
    }
}
