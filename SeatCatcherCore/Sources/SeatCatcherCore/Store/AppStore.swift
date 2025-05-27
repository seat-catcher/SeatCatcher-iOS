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
    public var trainCode: String?
    public var carCode: String?
    public var seatSectionType: SeatSectionType?
    public var isBlocked: Bool

    public init(
        user: User,
        trainCode: String? = nil,
        carCode: String? = nil,
        seatSectionType: SeatSectionType? = nil,
        isBlocked: Bool = true
    ) {
        self.user = user
        self.trainCode = trainCode
        self.carCode = carCode
        self.seatSectionType = seatSectionType
        self.isBlocked = isBlocked
    }

    public func setUser(_ user: User) {
        self.user = user
    }
}
