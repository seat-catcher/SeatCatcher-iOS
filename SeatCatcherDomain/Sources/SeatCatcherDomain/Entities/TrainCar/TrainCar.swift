//
//  TrainCar.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/27/25.
//

import Foundation

public struct TrainCar: Sendable, Equatable {
    public static func == (lhs: TrainCar, rhs: TrainCar) -> Bool {
        lhs.carCode == rhs.carCode && lhs.seatInfo == rhs.seatInfo
    }
    
    public init(carCode: String, seatInfo: [SeatSectionType : SeatSection]) {
        self.carCode = carCode
        self.seatInfo = seatInfo
    }
    
    public var carCode: String
    public var seatInfo: [SeatSectionType: SeatSection]
}
