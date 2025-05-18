//
//  Seat.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 4/16/25.
//

import Foundation

public struct Seat: Sendable, Identifiable {
    
    public let id: UUID = UUID()
    
    public var minutesLeft: Int // 하차까지 남은 시간(분)
    public var isAvailable: Bool // 앉을 수 있는 자리인지 여부
    public var isVisible: Bool // 화면에 띄울지 여부
    public var isSeated: Bool // 내가 앉아있는지 여부
    public var seatDirection: SeatDirection // UI 기준 좌석 방향

    public init(
        minutesLeft: Int,
        isAvailable: Bool,
        isVisible: Bool,
        isSeated: Bool,
        isBlocked: Bool,
        seatDirection: SeatDirection
    ) {
        self.minutesLeft = minutesLeft
        self.isAvailable = isAvailable
        self.isVisible = isVisible
        self.isSeated = isSeated
        self.seatDirection = seatDirection
    }
}

public enum SeatDirection: Sendable {
    case top // UI 기준 상단 좌석
    case bottom // UI 기준 하단 좌석
}
