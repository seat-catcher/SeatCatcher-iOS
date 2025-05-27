//
//  GetSeatInSectionUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/15/25.
//

import Foundation

public protocol GetSeatInSectionUseCase: Sendable {
    // seatSectionType 구역의 정보만 불러옵니다
    func execute(trainCar: TrainCar, seatSectionType: SeatSectionType) -> SeatSection
}

public final class GetSeatInSectionUseCaseImpl: GetSeatInSectionUseCase {
    
    public init() { }
    
    public func execute(trainCar: TrainCar, seatSectionType: SeatSectionType) -> SeatSection {
        return trainCar.seatInfo[seatSectionType] ?? SeatSection(topSeats: [:], bottomSeats: [:])
    }
}
