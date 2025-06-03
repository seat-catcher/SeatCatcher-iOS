//
//  AppStore.swift
//  SeatCatcherCore
//
//  Created by 박현수 on 4/14/25.
//

import Combine
import Foundation
import SeatCatcherDomain

@Observable
public final class AppStore {
    private var arrivalTimeCancellables = Set<AnyCancellable>()

    public var user: User
    
    // 메인피쳐에 필요한 상태 변수입니다
    public var trainCode: String? // 열차 번호
    public var carCode: String? // 차량 번호
    public var seatSectionType: SeatSectionType? // 열차 구역
    public var isBlocked: Bool // 좌석 잠금 상태
    public var carDirection: CarDirection? // 하행 상행 구분
    public var isSitting: Bool // 앉아있음 여부

    public var departure: Station?
    public var arrival: Station?
    public var incoming: Incoming?
    public var departureTime: Date?
    public var expectedArrivalTime: Date?

    public init(
        user: User,
        trainCode: String? = nil,
        carCode: String? = nil,
        seatSectionType: SeatSectionType? = nil,
        isBlocked: Bool = true,
        carDirection: CarDirection? = nil,
        isSitting: Bool = false,
        expectedArrivalTime: Date? = nil
    ) {
        self.user = user
        self.trainCode = trainCode
        self.carCode = carCode
        self.seatSectionType = seatSectionType
        self.isBlocked = isBlocked
        self.carDirection = carDirection
        self.isSitting = isSitting
        self.expectedArrivalTime = expectedArrivalTime
    }

    public func setUser(_ user: User) {
        self.user = user
    }

    public func subscribeArrivalPublisher(_ publisher: AnyPublisher<Date, Never>) {
        arrivalTimeCancellables.removeAll()

        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newDate in
                dump("appStore Received new Date")
                dump(newDate)
                self?.expectedArrivalTime = newDate
            }
            .store(in: &arrivalTimeCancellables)
    }
}
