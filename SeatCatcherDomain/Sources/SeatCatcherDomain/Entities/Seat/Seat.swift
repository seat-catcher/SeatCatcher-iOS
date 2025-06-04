//
//  Seat.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 4/16/25.
//

import Foundation

public struct Seat: Sendable, Identifiable {
    
    public var id: Int // 좌석 식별자 (서버에서 제공)
    public var seatType: SeatType // 좌석 구분
    public var seatDirection: SeatDirection // UI 기준 좌석 방향
    public var occupant: Occupant? // 착석 유저 정보

    public init(
        id: Int,
        seatType: SeatType,
        seatDirection: SeatDirection,
        occupant: Occupant?
    ) {
        self.id = id
        self.seatType = seatType
        self.seatDirection = seatDirection
        self.occupant = occupant
    }
}

public enum SeatDirection: Sendable {
    case top // UI 기준 상단 좌석
    case bottom // UI 기준 하단 좌석
}

public enum SeatType: Sendable {
    case normal // 일반석
    case pregnant // 임산부석
    case priority // 교통약자석
}
