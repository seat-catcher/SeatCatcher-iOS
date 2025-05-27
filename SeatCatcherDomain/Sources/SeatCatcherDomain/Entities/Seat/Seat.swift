//
//  Seat.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 4/16/25.
//

import Foundation

public struct Seat: Sendable, Identifiable {
    
    public let id: Int // 좌석 식별자 (서버에서 제공)
    
    public var minutesLeft: Int // 하차까지 남은 시간(분)
    public var isAvailable: Bool // 앉을 수 있는 자리인지 여부
    public var isSeated: Bool // 내가 앉아있는지 여부
    public var seatType: SeatType // 좌석 구분
    public var seatDirection: SeatDirection // UI 기준 좌석 방향

    public init(
        id: Int,
        minutesLeft: Int,
        isAvailable: Bool,
        isSeated: Bool,
        isBlocked: Bool,
        seatType: SeatType,
        seatDirection: SeatDirection
    ) {
        self.id = id
        self.minutesLeft = minutesLeft
        self.isAvailable = isAvailable
        self.isSeated = isSeated
        self.seatType = seatType
        self.seatDirection = seatDirection
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
