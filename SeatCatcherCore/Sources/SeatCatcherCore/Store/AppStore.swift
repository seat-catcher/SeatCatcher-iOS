//
//  AppStore.swift
//  SeatCatcherCore
//
//  Created by 박현수 on 4/14/25.
//

import Foundation
import SeatCatcherDomain

@Observable
public final class AppStore {
    public var user: User
    
    // 메인피쳐에 필요한 상태 변수입니다
    public var trainCode: String? // 열차 번호
    public var carCode: String? // 차량 번호
    public var seatSectionType: SeatSectionType? // 열차 구역
    public var isBlocked: Bool // 좌석 잠금 상태
    public var carDirection: CarDirection? // 하행 상행 구분
    public var isSitting: Bool // 앉아있음 여부

    public init(
        user: User,
        trainCode: String? = nil,
        carCode: String? = nil,
        seatSectionType: SeatSectionType? = nil,
        isBlocked: Bool = true,
        carDirection: CarDirection? = nil,
        isSitting: Bool = false
    ) {
        self.user = user
        self.trainCode = trainCode
        self.carCode = carCode
        self.seatSectionType = seatSectionType
        self.isBlocked = isBlocked
        self.carDirection = carDirection
        self.isSitting = isSitting
    }

    public func setUser(_ user: User) {
        self.user = user
    }
}
