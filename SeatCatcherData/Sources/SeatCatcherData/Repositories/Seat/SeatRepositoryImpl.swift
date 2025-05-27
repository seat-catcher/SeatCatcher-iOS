//
//  SeatRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 5/18/25.
//

import Foundation
import SeatCatcherDomain

public final class SeatRepositoryImpl: SeatRepository, Sendable {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getSeatsInTrainCar(trainCode: Int, carCode: Int) async throws -> TrainCar {
        let response = try await networkService.getSeatInfo(trainCode: trainCode, carCode: carCode)
        
        var trainCar: TrainCar = .init(
            carCode: carCode,
            seatInfo: [:]
        )
        
        for seatInfo in response {
            // SeatSectionType 매핑
            guard let sectionType = SeatSectionType(rawValue: seatInfo.seatGroupType) else {
                throw SeatRepositoryError.invalidSeatGroupType(seatInfo.seatGroupType)
            }

            // 좌석 배치 추출
            let rowCount = try sectionType.calculateRowCount(seatInfo.seatGroupType)
            
            // 기존 SeatSection 가져오기 또는 새로 생성
            var seatSection = trainCar.seatInfo[sectionType] ?? SeatSection(
                type: sectionType,
                topSeats: [:],
                bottomSeats: [:]
            )
            
            // Seat 매핑
            for seat in seatInfo.seatStatus {
                // 배치에 따라 topSeat와 bottomSeat 구분
                let isTopSeat = seat.seatLocation < rowCount
                let seatDirection: SeatDirection = isTopSeat ? .top : .bottom
                // 좌석 구분 매핑
                guard let seatType = SeatType(rawValue: seat.seatType) else {
                    throw SeatRepositoryError.invalidSeatType(seat.seatType)
                }
                // 모델과 DTO 매핑
                let seatModel = Seat(
                    id: seat.seatId,
                    minutesLeft: seat.occupant?.getOffRemainingCount ?? 0,
                    isAvailable: seat.occupant == nil,
                    isSeated: seat.occupant?.userId == 0, // FIXME: AppStore 프로퍼티와 비교
                    isBlocked: seat.occupant != nil,
                    seatType: seatType,
                    seatDirection: seatDirection
                )
                // topSeat와 bottomSeat에 추가 (중복 seatLocation 확인)
                if isTopSeat {
                    if seatSection.topSeats[seat.seatLocation] != nil {
                        throw SeatRepositoryError.duplicateSeatLocation(seat.seatLocation, sectionType)
                    }
                    seatSection.topSeats[seat.seatLocation] = seatModel
                } else {
                    if seatSection.bottomSeats[seat.seatLocation] != nil {
                        throw SeatRepositoryError.duplicateSeatLocation(seat.seatLocation, sectionType)
                    }
                    seatSection.bottomSeats[seat.seatLocation] = seatModel
                }
            }
            
            // SeatSection 저장
            trainCar.seatInfo[sectionType] = seatSection
        }
        return trainCar
    }

    public func unlockAllSeats() async throws {
        return
    }
}

// 에러 타입 정의
public enum SeatRepositoryError: Error {
    case invalidSeatGroupType(String)
    case invalidSeatType(String)
    case invalidSeatRow
    case duplicateSeatLocation(Int, SeatSectionType)
}

// 구역 구분 매핑
fileprivate extension SeatSectionType {
    init?(rawValue: String) {
        switch rawValue {
        case _ where rawValue.hasPrefix("NORMAL_A"): self = .normal_A
        case _ where rawValue.hasPrefix("NORMAL_B"): self = .normal_B
        case _ where rawValue.hasPrefix("NORMAL_C"): self = .normal_C
        case _ where rawValue.hasPrefix("PRIORITY_A"): self = .priority_A
        case _ where rawValue.hasPrefix("PRIORITY_B"): self = .priority_B
        default: return nil
        }
    }
    
    func calculateRowCount(_ seatGroupType: String) throws -> Int {
        switch self {
        case .priority_A, .priority_B:
            return 6
        default:
            let components = seatGroupType.split(separator: "_")
            guard let numberString = components.last,
                  let totalSeats = Int(numberString) else {
                throw SeatRepositoryError.invalidSeatRow
            }
            return totalSeats / 2
        }
    }
}

// 좌석 구분 매핑
fileprivate extension SeatType {
    init?(rawValue: String) {
        switch rawValue {
        case "NORMAL": self = .normal
        case "PREGNANT": self = .pregnant
        case "PRIORITY": self = .priority
        default: return nil
        }
    }
}
