//
//  GetSeatInfoResponseDTO.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 5/27/25.
//

import SeatCatcherDomain
import SwiftUI

typealias GetSeatInTrainCarResponseDTO = [SeatInCarInfo]

struct SeatInCarInfo: Codable {
    let trainCode, carCode, seatGroupType: String
    let seatStatus: [SeatInfo]
}

struct SeatInfo: Codable {
    let seatId, seatLocation: Int
    let seatType: String
    let occupant: OccupantInfo?
}

struct OccupantInfo: Codable {
    let userId: Int
    let nickname: String
    let getOffRemainingCount: Int?
    let profileImageNum: String // FIXME: 서버 작업 중
    let getOffStation: String? // FIXME: 서버 작업 중
    let tags: [String] // FIXME: 서버 작업 중
    
    static var stub: Self {
        .init(
            userId: 1,
            nickname: "신기한 발바닥",
            getOffRemainingCount: 33,
            profileImageNum: "IMAGE_1",
            getOffStation: "상도역",
            tags: ["USERTAG_LONGDISTANCE", "USERTAG_CARRIER"]
        )
    }
}

extension GetSeatInTrainCarResponseDTO: ResponseDTO {
    
    typealias DomainModel = TrainCar
    
    static var stub: Self {
        [
            SeatInCarInfo(
                trainCode: "0000",
                carCode: "1234",
                seatGroupType: "NORMAL_A_14",
                seatStatus: [
                    SeatInfo(seatId: 1, seatLocation: 0, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 2, seatLocation: 1, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 3, seatLocation: 2, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 4, seatLocation: 3, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 5, seatLocation: 4, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 6, seatLocation: 5, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 7, seatLocation: 6, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 8, seatLocation: 7, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 9, seatLocation: 8, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 10, seatLocation: 9, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 11, seatLocation: 10, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 12, seatLocation: 11, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 13, seatLocation: 12, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 14, seatLocation: 13, seatType: "PREGNANT", occupant: nil)
                ]
            ),
            SeatInCarInfo(
                trainCode: "0000",
                carCode: "1234",
                seatGroupType: "NORMAL_B_14",
                seatStatus: [
                    SeatInfo(seatId: 15, seatLocation: 0, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 16, seatLocation: 1, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 17, seatLocation: 2, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 18, seatLocation: 3, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 19, seatLocation: 4, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 20, seatLocation: 5, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 21, seatLocation: 6, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 22, seatLocation: 7, seatType: "PREGNANT", occupant: .stub),
                    SeatInfo(seatId: 23, seatLocation: 8, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 24, seatLocation: 9, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 25, seatLocation: 10, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 26, seatLocation: 11, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 27, seatLocation: 12, seatType: "NORMAL", occupant: .stub),
                    SeatInfo(seatId: 28, seatLocation: 13, seatType: "PREGNANT", occupant: nil)
                ]
            ),
            SeatInCarInfo(
                trainCode: "0000",
                carCode: "1234",
                seatGroupType: "NORMAL_C_14",
                seatStatus: [
                    SeatInfo(seatId: 29, seatLocation: 0, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 30, seatLocation: 1, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 31, seatLocation: 2, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 32, seatLocation: 3, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 33, seatLocation: 4, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 34, seatLocation: 5, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 35, seatLocation: 6, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 36, seatLocation: 7, seatType: "PREGNANT", occupant: nil),
                    SeatInfo(seatId: 37, seatLocation: 8, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 38, seatLocation: 9, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 39, seatLocation: 10, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 40, seatLocation: 11, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 41, seatLocation: 12, seatType: "NORMAL", occupant: nil),
                    SeatInfo(seatId: 42, seatLocation: 13, seatType: "PREGNANT", occupant: nil)
                ]
            ),
            SeatInCarInfo(
                trainCode: "0000",
                carCode: "1234",
                seatGroupType: "PRIORITY_A",
                seatStatus: [
                    SeatInfo(seatId: 43, seatLocation: 0, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 44, seatLocation: 1, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 45, seatLocation: 2, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 46, seatLocation: 3, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 47, seatLocation: 4, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 48, seatLocation: 5, seatType: "PRIORITY", occupant: nil)
                ]
            ),
            SeatInCarInfo(
                trainCode: "0000",
                carCode: "1234",
                seatGroupType: "PRIORITY_B",
                seatStatus: [
                    SeatInfo(seatId: 55, seatLocation: 0, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 56, seatLocation: 1, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 57, seatLocation: 2, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 58, seatLocation: 3, seatType: "PRIORITY", occupant: .stub),
                    SeatInfo(seatId: 59, seatLocation: 4, seatType: "PRIORITY", occupant: nil),
                    SeatInfo(seatId: 60, seatLocation: 5, seatType: "PRIORITY", occupant: .stub),
                ]
            )
        ]
    }
    
    var domainModel: TrainCar {
        var seatInfo: [SeatSectionType: SeatSection] = [:]
        
        for seatInCar in self {
            do {
                let sectionType = try SeatSectionType(string: seatInCar.seatGroupType)
                let rowCount = try sectionType.calculateRowCount(seatInCar.seatGroupType)
                var seatSection = seatInfo[sectionType] ?? SeatSection(topSeats: [:], bottomSeats: [:])
                
                for seat in seatInCar.seatStatus {
                    guard let seatModel = try mapToSeat(seat, rowCount: rowCount) else { continue }
                    let isTopSeat = seat.seatLocation < rowCount
                    
                    if isTopSeat {
                        seatSection.topSeats[seat.seatLocation] = seatModel
                    } else {
                        seatSection.bottomSeats[seat.seatLocation - rowCount] = seatModel
                    }
                }
                seatInfo[sectionType] = seatSection
            } catch(let error as SeatCatcherDataError) {
                print(error.description)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return TrainCar(
            carCode: self.first?.carCode ?? "",
            seatInfo: seatInfo
        )
    }
    
    private func mapToSeat(_ seat: SeatInfo, rowCount: Int) throws -> Seat? {
        let seatType = try SeatType(rawValue: seat.seatType)
        let isTopSeat = seat.seatLocation < rowCount
        let occupant = seat.occupant?.mapToOccupant()
        
        return Seat(
            id: seat.seatId,
            seatType: seatType,
            seatDirection: isTopSeat ? .top : .bottom,
            occupant: occupant
        )
    }
    
}

extension OccupantInfo {
    fileprivate func mapToOccupant() -> Occupant {
        Occupant(
            id: userId,
            name: nickname,
            profileImage: UserImage(rawValue: profileImageNum) ?? .catchy1,
            tags: tags.compactMap { UserTag(rawValue: $0) },
            minutesLeftToGetOff: getOffRemainingCount ?? 0,
            stationToGetOff: getOffStation ?? ""
        )
    }
}

fileprivate extension SeatSectionType {
    // 구역 구분 매핑
    init(string: String) throws {
        switch string {
        case _ where string.hasPrefix("NORMAL_A"): self = .normal_A
        case _ where string.hasPrefix("NORMAL_B"): self = .normal_B
        case _ where string.hasPrefix("NORMAL_C"): self = .normal_C
        case _ where string.hasPrefix("PRIORITY_A"): self = .priority_A
        case _ where string.hasPrefix("PRIORITY_B"): self = .priority_B
        default: throw SeatCatcherDataError.InvalidSeatSectionType
        }
    }
    
    // 좌석 배치 파싱
    func calculateRowCount(_ seatGroupType: String) throws -> Int {
        switch self {
        case .priority_A, .priority_B:
            return 3
        default:
            let components = seatGroupType.split(separator: "_")
            guard let numberString = components.last,
                  let totalSeats = Int(numberString) else {
                throw SeatCatcherDataError.FailedToGetRowCount
            }
            return totalSeats / 2
        }
    }
}

// 좌석 구분 매핑
fileprivate extension SeatType {
    init(rawValue: String) throws {
        switch rawValue {
        case "NORMAL": self = .normal
        case "PREGNANT": self = .pregnant
        case "PRIORITY": self = .priority
        default: throw SeatCatcherDataError.InvalidSeatType
        }
    }
}
