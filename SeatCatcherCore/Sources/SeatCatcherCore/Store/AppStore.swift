//
//  AppStore.swift
//  SeatCatcherCore
//
//  Created by 박현수 on 4/14/25.
//

import Foundation
import Combine
import SeatCatcherDomain

@Observable
public final class AppStore {
    public var user: User
    
    // MARK: - 메인피쳐
    /// 메인피쳐 승/하차 플로우에 필요한 상태 변수입니다
    public var trainCode: String? // 열차 번호
    public var carCode: String? // 차량 번호
    public var seatSectionType: SeatSectionType? // 열차 구역
    public var isBlocked: Bool // 좌석 잠금 상태
    public var carDirection: CarDirection? // 하행 상행 구분
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
    private var cancellables = Set<AnyCancellable>() // subscriber 저장
    private var subscribedTopics: Set<String> = [] // 구독한 토픽
    /// STOMP 연결 상태
    private var isStompConnected: Bool? {
        didSet {
            _isStompConnectedPublisher.send(isStompConnected)
        }
    }
    private let _isStompConnectedPublisher = PassthroughSubject<Bool?, Never>()
    public var isStompConnectedPublisher: AnyPublisher<Bool?, Never> {
        _isStompConnectedPublisher.eraseToAnyPublisher()
    }
    
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
    
    public func subscribeToTrainPublisher(_ publisher: AnyPublisher<TrainCar, Error>?, topic: String) {
        guard let publisher, !subscribedTopics.contains(topic) else { return }
        subscribedTopics.insert(topic)
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
            .store(in: &cancellables)
    }
    
    public func subscribeToSeatRequesterPublisher(_ publisher: AnyPublisher<SeatRequester, Error>?) {
        guard let publisher else { return }
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
            .store(in: &cancellables)
    }
    
    public func subscribeToSeatRequesteePublisher(_ publisher: AnyPublisher<SeatRequestee, Error>?) {
        guard let publisher else { return }
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
            .store(in: &cancellables)
    }
    
    public func subscribeToStompConnection(_ publisher: AnyPublisher<Bool, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isStompConnected = isConnected
            }
            .store(in: &cancellables)
    }
    
    public func unsubscribeAll() {
        cancellables.removeAll()
        subscribedTopics.removeAll()
    }
}
