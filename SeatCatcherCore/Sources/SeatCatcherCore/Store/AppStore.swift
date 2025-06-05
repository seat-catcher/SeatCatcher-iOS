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
    public var user: User

    public var isOnJourney: Bool { expectedArrivalTime != nil }

    // MARK: - 메인피쳐
    /// 메인피쳐 승/하차 플로우에 필요한 상태 변수입니다
    public var departure: Station?
    public var arrival: Station?
    public var incoming: Incoming?
    public var departureTime: Date?
    public var expectedArrivalTime: Date?
    public var trainCode: String? { incoming?.trainCode } // 열차 번호
    public var carCode: String? // 차량 번호
    public var seatSectionType: SeatSectionType? // 열차 구역
    public var isBlocked: Bool // 좌석 잠금 상태
    public var carDirection: CarDirection? { incoming?.carDirection } // 하행 상행 구분
    public var isSitting: Bool // 앉아있음 여부
    /// 메인피쳐 좌석 정보 업데이트에 필요한 열차 좌석 정보 퍼블리셔입니다
    private var trainCar: TrainCar? {
        didSet {
            _trainCarPublisher.send(trainCar)
        }
    }
    private let _trainCarPublisher = PassthroughSubject<TrainCar?, Never>()
    public var trainCarPublisher: AnyPublisher<TrainCar?, Never> {
        _trainCarPublisher.eraseToAnyPublisher()
    }
    
    
    // MARK: - 좌석 요청
    /// 메인피쳐 양보 플로우에 필요한 상태 퍼블리셔입니다
    /// 좌석점유 시 좌석 요청자의 요청
    private var seatRequester: SeatRequester? {
        didSet {
            _seatRequesterPublisher.send(seatRequester)
        }
    }
    private let _seatRequesterPublisher = PassthroughSubject<SeatRequester?, Never>()
    public var seatRequesterPublisher: AnyPublisher<SeatRequester?, Never> {
        _seatRequesterPublisher.eraseToAnyPublisher()
    }
    /// 좌석요청 시 좌석 점유자의 응답
    private var seatRequestee: SeatRequestee? {
        didSet {
            _seatRequesteePublisher.send(seatRequestee)
        }
    }
    private let _seatRequesteePublisher = PassthroughSubject<SeatRequestee?, Never>()
    public var seatRequesteePublisher: AnyPublisher<SeatRequestee?, Never> {
        _seatRequesteePublisher.eraseToAnyPublisher()
    }

    // MARK: - Combine 및 STOMP 구독
    /// 구독 관리에 필요한 변수 및 퍼블리셔입니다
    private var trainCarCancellables = Set<AnyCancellable>()
    private var seatRequesterCancellables = Set<AnyCancellable>()
    private var seatRequesteeCancellables = Set<AnyCancellable>()
    private var arrivalTimeCancellables = Set<AnyCancellable>()

    private let endJourneyUseCase: EndJourneyUseCase

    public init(
        user: User,
        carCode: String? = nil,
        seatSectionType: SeatSectionType? = nil,
        isBlocked: Bool = true,
        isSitting: Bool = false,
        expectedArrivalTime: Date? = nil,
        endJourneyUseCase: EndJourneyUseCase
    ) {
        self.user = user
        self.carCode = carCode
        self.seatSectionType = seatSectionType
        self.isBlocked = isBlocked
        self.isSitting = isSitting
        self.expectedArrivalTime = expectedArrivalTime
        self.endJourneyUseCase = endJourneyUseCase
    }

    public func setUser(_ user: User) {
        self.user = user
    }
    
    public func subscribeToTrainPublisher(_ publisher: AnyPublisher<TrainCar, Error>, trainCode: String) {
        trainCarCancellables.removeAll()
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        dump("열차 정보 오류: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] trainCar in
                    guard self?.trainCar != trainCar else { return }
                    self?.trainCar = trainCar
                }
            )
            .store(in: &trainCarCancellables)
    }
    
    public func subscribeToSeatRequesterPublisher(_ publisher: AnyPublisher<SeatRequester, Error>, seatId: Int) {
        seatRequesterCancellables.removeAll()
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        dump("좌석 요청 수신 오류: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] requester in
                    self?.seatRequester = requester
                }
            )
            .store(in: &seatRequesterCancellables)
    }
    
    public func subscribeToSeatRequesteePublisher(_ publisher: AnyPublisher<SeatRequestee, Error>, seatId: Int) {
        seatRequesteeCancellables.removeAll()
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        dump("좌석 요청 응답 수신 오류: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] requestee in
                    self?.seatRequestee = requestee
                }
            )
            .store(in: &seatRequesteeCancellables)
    }

    public func startJourney(
        carCode: String,
        incoming: Incoming,
        departure: Station,
        arrival: Station,
        expectedArrivalTime: Date,
        arrivalTimePublisher: AnyPublisher<PathArrivalTime, Never>
    ) {
        self.carCode = carCode
        self.incoming = incoming
        self.departure = departure
        self.arrival = arrival
        self.departureTime = Date()
        self.expectedArrivalTime = expectedArrivalTime
        subscribeArrivalPublisher(arrivalTimePublisher)
    }

    private func endJourney() {
        self.carCode = nil
        self.incoming = nil
        self.departure = nil
        self.arrival = nil
        self.departureTime = nil
        self.expectedArrivalTime = nil

        trainCarCancellables.removeAll()
        seatRequesterCancellables.removeAll()
        seatRequesteeCancellables.removeAll()
        arrivalTimeCancellables.removeAll()

        endJourneyUseCase.execute()
    }

    private func subscribeArrivalPublisher(_ publisher: AnyPublisher<PathArrivalTime, Never>) {
        arrivalTimeCancellables.removeAll()

        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pathArrivalTime in
                guard let self = self else { return }
                self.expectedArrivalTime = pathArrivalTime.expectedArrivalTime

                if pathArrivalTime.arrived { endJourney() }
            }
            .store(in: &arrivalTimeCancellables)
    }
}
