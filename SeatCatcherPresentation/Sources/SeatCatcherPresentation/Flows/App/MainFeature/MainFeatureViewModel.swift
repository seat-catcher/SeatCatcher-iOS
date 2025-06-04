//
//  MainFeatureViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/16/25.
//

import Foundation
import Combine
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class MainFeatureViewModel: ViewModel {
    
    // MARK: Action Definition
    enum Action {
        case willAppear // 초기 상태
        case backButtonDidTap // 백 버튼
        case homeButtonDidTap // 홈 버튼
        case manageMySeatButtonDidTap // 좌석 관리 버튼
        case willRegisterSeat(Seat) // 좌석 등록
        case willMoveSeat(Seat) // 좌석 이동
        case willCancelSeat(Seat) // 좌석 취소
        case backToSeatSectionPage // 좌석 구역 페이지로 이동
        case manageSeatSection(SeatSectionAction) // 좌석 관리 액션 수행
        case manageSeatRequest(SeatRequestAction) // 좌석 요청 관련 액션 수행
    }
    
    enum SeatSectionAction {
        case willSelectSeat(Seat) // 좌석 선택
        case willUnlockAllSeats // 좌석 정보 잠금 해제
    }
    
    enum SeatRequestAction {
        case willRequestSeat(_ seat: Seat, creditAmount: Int) // 좌석 요청
        case willCancelRequestSeat(_ seat: Seat, creditAmount: Int) // 좌석 요청 취소
        case willAcceptSeatRequest(_ seat: Seat, requester: SeatRequester) // 좌석 요청 수락
        case willRejectSeatRequest(_ seat: Seat, requester: SeatRequester) // 좌석 요청 거절
    }
    
    // MARK: State Definition
    struct State {
        var trainCode: String // 열차 코드
        var carCode: String // 차량 코드
        var showNoInformationToast: Bool // 좌석 정보가 없어요 토스트 메시지 띄움 여부
        var userStatus: UserStatus // 유저의 선택 상황
        var seatSectionType: SeatSectionType // 현재 보고있는 구역
        var lookingCount: Int // 현재 열차 내 자리를 찾는 사용자 수, 0의 경우 띄우지 않음
        var seatSectionState: SeatSectionState
        var seatRequestState: SeatRequestState
    }
    
    struct SeatSectionState {
        var selectedSeat: Seat? // 선택한 좌석
        var mySeat: Seat? // 내가 앉은 좌석
        var isBlocked: Bool // 좌석 정보 잠금 상태
        var seats: SeatSection // 좌석 정보
    }
    
    struct SeatRequestState {
        var requesters: [SeatRequester]? // 좌석 점유자일 때 - 좌석 요청자(요청 정보) 리스트
        var requestee: SeatRequestee? // 좌석 요청자일 때 - 좌석 점유자(응답 정보)
    }
    
    // MARK: Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Dependencies
    let store: AppStore
    let coordinator: Coordinator
    
    // MARK: States
    private(set) var state: State
    
    // MARK: UseCases
    /// 필수 유즈케이스
    private let getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase
    private let getSeatInSectionUseCase: GetSeatInSectionUseCase
    private let unlockSeatUseCase: UnlockSeatUseCase
    /// 옵셔널 유즈케이스 - 좌석 등록 시
    private let registerSeatUseCase: RegisterSeatUseCase?
    /// 옵셔널 유즈케이스 - 좌석 이동 시
    private let moveSeatUseCase: MoveSeatUseCase?
    /// 옵셔널 유즈케이스 - 좌석 취소 시
    private let cancelSeatUseCase: CancelSeatUseCase?
    /// 옵셔널 유즈케이스 - 일반 상태
    private let subscribeTrainUseCase: SubscribeTrainUseCase?
    /// 옵셔널 유즈케이스 - 좌석 요청자
    private let postSeatRequestUseCase : RequestSeatUseCase?
    private let cancelSeatRequestUseCase : CancelRequestSeatUseCase?
    /// 옵셔널 유즈케이스 - 좌석 점유자
    private let acceptSeatRequestUseCase : AcceptRequestSeatUseCase?
    private let rejectSeatRequestUseCase : RejectRequestSeatUseCase?
    
    
    // MARK: Initialize
    @MainActor
    public init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        subscribeTrainUseCase: SubscribeTrainUseCase? = nil,
        registerSeatUseCase: RegisterSeatUseCase? = nil,
        moveSeatUseCase: MoveSeatUseCase? = nil,
        cancelSeatUseCase: CancelSeatUseCase? = nil,
        postSeatRequestUseCase : RequestSeatUseCase? = nil,
        cancelSeatRequestUseCase : CancelRequestSeatUseCase? = nil,
        acceptSeatRequestUseCase : AcceptRequestSeatUseCase? = nil,
        rejectSeatRequestUseCase : RejectRequestSeatUseCase? = nil,
        userStatus: UserStatus
    ) {
        self.store = store
        self.coordinator = coordinator
        self.getSeatInTrainCarUseCase = getSeatInTrainCarUseCase
        self.getSeatInSectionUseCase = getSeatInSectionUseCase
        self.unlockSeatUseCase = unlockSeatUseCase
        self.subscribeTrainUseCase = subscribeTrainUseCase
        self.registerSeatUseCase = registerSeatUseCase
        self.moveSeatUseCase = moveSeatUseCase
        self.cancelSeatUseCase = cancelSeatUseCase
        self.postSeatRequestUseCase = postSeatRequestUseCase
        self.cancelSeatRequestUseCase = cancelSeatRequestUseCase
        self.acceptSeatRequestUseCase = acceptSeatRequestUseCase
        self.rejectSeatRequestUseCase = rejectSeatRequestUseCase
        self.state = .init(
            trainCode: store.trainCode ?? "",
            carCode: store.carCode ?? "",
            showNoInformationToast: false, // 초깃값
            userStatus: userStatus,
            seatSectionType: store.seatSectionType ?? .normal_A,
            lookingCount: 0, // 초깃값
            seatSectionState: .init(
                selectedSeat: nil,
                isBlocked: store.isBlocked,
                seats: .init(topSeats: [:], bottomSeats: [:])
            ),
            seatRequestState: .init(
                requesters: [], // 초깃값
                requestee: nil // 초깃값
            )
        )
    }
    
    
    // MARK: 기본
    @MainActor
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        subscribeTrainUseCase: SubscribeTrainUseCase,
        postSeatRequestUseCase : RequestSeatUseCase,
        cancelSeatRequestUseCase : CancelRequestSeatUseCase,
        acceptSeatRequestUseCase : AcceptRequestSeatUseCase,
        rejectSeatRequestUseCase : RejectRequestSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            subscribeTrainUseCase: subscribeTrainUseCase,
            postSeatRequestUseCase : postSeatRequestUseCase,
            cancelSeatRequestUseCase : cancelSeatRequestUseCase,
            acceptSeatRequestUseCase : acceptSeatRequestUseCase,
            rejectSeatRequestUseCase : rejectSeatRequestUseCase,
            userStatus: store.isSitting ? .seated : .standing
        )
    }
    
    // MARK: 좌석 등록하는 경우
    @MainActor
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        registerSeatUseCase: RegisterSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            registerSeatUseCase: registerSeatUseCase,
            userStatus: .registering
        )
    }
    
    // MARK: 좌석 이동하는 경우
    @MainActor
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        moveSeatUseCase: MoveSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            moveSeatUseCase: moveSeatUseCase,
            userStatus: .moving
        )
    }
    
    // MARK: 좌석 취소하는 경우
    @MainActor
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        cancelSeatUseCase: CancelSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            cancelSeatUseCase: cancelSeatUseCase,
            userStatus: .cancelling
        )
    }
    
    // MARK: action
    @MainActor
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchSeatInSection()
            if state.userStatus == .standing || state.userStatus == .seated {
                setupStoreObservers()
            }
        case let .manageSeatSection(seatSectionAction):
            handleSeatSectionAction(seatSectionAction)
        case .backButtonDidTap:
            coordinator.pop()
        case .homeButtonDidTap:
            coordinator.popToRoot()
        case .manageMySeatButtonDidTap:
            coordinator.push(AppScene.manageSeat)
        case let .willRegisterSeat(seat):
            registerSeat(seat)
        case let .willMoveSeat(seat):
            moveSeat(seat)
        case let .willCancelSeat(seat):
            cancelSeat(seat)
        case .backToSeatSectionPage:
            coordinator.pop()
        case let .manageSeatRequest(type):
            switch type {
            case let .willRequestSeat(seat, creditAmount):
                postSeatRequest(seat, creditAmount: creditAmount)
            case let .willCancelRequestSeat(seat, creditAmount):
                cancelSeatRequest(seat, creditAmount: creditAmount)
            case let .willAcceptSeatRequest(seat, requester):
                acceptSeatRequest(seat, requester: requester)
            case let .willRejectSeatRequest(seat, requester):
                rejectSeatRequest(seat, requester: requester)
            }
        }
    }
    
    /// 메인피쳐 기본 상태일 시에만 수행합니다
    /// 좌석 등록 / 이동 / 취소 시엔 STOMP 없이 REST API만 작동합니다
    @MainActor
    private func setupStoreObservers() {
        /// 좌석 정보 업데이트 퍼블리셔
        store.trainCarPublisher
            .sink { [weak self] trainCar in
                guard let self, let trainCar else { return }
                /// 현재 보고 있는 구역의 좌석 정보만을 가져옵니다
                state.seatSectionState.seats = getSeatInSectionUseCase.execute(
                    trainCar: trainCar,
                    seatSectionType: state.seatSectionType
                )
                /// UI에 표시하기 위해 나의 좌석을 찾습니다
                state.seatSectionState.mySeat = findMySeat()
            }
            .store(in: &cancellables)
        /// 좌석 요청(자)  퍼블리셔
        store.seatRequesterPublisher
            .sink { [weak self] requester in
                if let requester = requester {
                    /// 동일한 유저의 기존 요청이 있다면 제거합니다
                    self?.state.seatRequestState.requesters?.removeAll {
                        $0.requesterId == requester.requesterId
                    }
                    if let creditAmount = requester.creditAmount {
                        /// creditAmount가 포함되어있으므로 새로운 요청을 추가합니다
                        self?.state.seatRequestState.requesters?.append(requester)
                    } else {
                        /// creditAmount가 없으므로 기존 요청 취소만 수행합니다
                        return
                    }
                }
            }
            .store(in: &cancellables)
        /// 좌석 요청 응답(자)  퍼블리셔
        store.seatRequesteePublisher
            .sink { [weak self] requestee in
                if let requestee = requestee {
                    self?.state.seatRequestState.requestee = requestee
                }
            }
            .store(in: &cancellables)
    }
    
    /// 구독 해제
    @MainActor
    private func unsubscribe() { // TODO: - 백그라운드에서도 연결 유지해야하므로 추후 검토 후 삭제
        if let subscribeTrainUseCase {
            subscribeTrainUseCase.unsubscribe(trainCode: state.trainCode)
            cancellables.removeAll()
        }
    }
    
    @MainActor
    private func handleSeatSectionAction(_ action: SeatSectionAction) {
        switch action {
        case .willSelectSeat(let seat):
            /// 좌석을 선택합니다
            if state.userStatus != .cancelling { // 좌석 취소 중에는 선택 불가
                if state.seatSectionState.selectedSeat?.id == seat.id {
                    state.seatSectionState.selectedSeat = nil
                } else {
                    state.seatSectionState.selectedSeat = seat
                }
            }
        case .willUnlockAllSeats:
            /// 좌석 정보를 잠금 해제합니다
            Task {
                do {
                    try await unlockSeatUseCase.execute()
                    state.seatSectionState.isBlocked = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    @MainActor
    private func fetchSeatInSection() {
        let currentTrainCode = state.trainCode
        let currentCarCode = state.carCode
        let currentSeatSectionType = state.seatSectionType
        let currentUserStatus = state.userStatus
        Task {
            do {
                let trainCar = try await getSeatInTrainCarUseCase.execute(trainCode: currentTrainCode, carCode: currentCarCode)
                await MainActor.run {
                    /// 현재 구역의 좌석 데이터만 필터링
                    state.seatSectionState.seats = getSeatInSectionUseCase.execute(trainCar: trainCar, seatSectionType: currentSeatSectionType)
                    
                    /// 나의 좌석 반영
                    state.seatSectionState.mySeat = findMySeat()
                    
                    /// 나의 좌석 선택 처리 (좌석 등록 / 이동 시)
                    if currentUserStatus == .registering || currentUserStatus == .moving {
                        state.seatSectionState.selectedSeat = state.seatSectionState.mySeat
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func findMySeat() -> Seat? {
        return state.seatSectionState.seats.topSeats.values.first { $0.occupant?.id == store.user.id }
        ?? state.seatSectionState.seats.bottomSeats.values.first { $0.occupant?.id == store.user.id }
    }
    
    @MainActor
    private func registerSeat(_ seat: Seat) {
        /// 좌석 정보를 등록합니다
        if let registerSeatUseCase {
            Task {
                do {
                    let requesterPublisher = try await registerSeatUseCase.execute(seat)
                    self.store.subscribeToSeatRequesterPublisher(requesterPublisher)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func moveSeat(_ newSeat: Seat) {
        /// 좌석 정보를 이동합니다
        if let moveSeatUseCase, let oldSeat = self.state.seatSectionState.mySeat {
            Task {
                do {
                    let requesterPublisher = try await moveSeatUseCase.execute(from: oldSeat, to: newSeat)
                    self.store.subscribeToSeatRequesterPublisher(requesterPublisher)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func cancelSeat(_ seat: Seat) {
        /// 좌석 정보를 취소합니다
        if let cancelSeatUseCase {
            Task {
                do {
                    try await cancelSeatUseCase.execute(seat)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func postSeatRequest(_ seat: Seat, creditAmount: Int) {
        /// 좌석 요청을 송신합니다
        if let postSeatRequestUseCase {
            Task {
                do {
                    let requesteePublisher = try await postSeatRequestUseCase.execute(seat, requesterId: store.user.id, creditAmount: creditAmount)
                    store.subscribeToSeatRequesteePublisher(requesteePublisher)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func cancelSeatRequest(_ seat: Seat, creditAmount: Int) {
        /// 좌석 요청을 취소합니다
        if let cancelSeatRequestUseCase {
            Task {
                do {
                    try await cancelSeatRequestUseCase.execute(seat, requesterId: store.user.id, creditAmount: creditAmount)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func acceptSeatRequest(_ seat: Seat, requester: SeatRequester) {
        /// 좌석 요청을 수락합니다
        if let acceptSeatRequestUseCase {
            Task {
                do {
                    try await acceptSeatRequestUseCase.execute(seat, requester: requester)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func rejectSeatRequest(_ seat: Seat, requester: SeatRequester) {
        /// 좌석 요청을 거절합니다
        if let rejectSeatRequestUseCase {
            Task {
                do {
                    try await rejectSeatRequestUseCase.execute(seat, requester: requester)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public enum UserStatus: Sendable {
        case seated // 착석 중
        case standing // 자리 찾는 중
        case registering // 좌석 관리 - 앉은 자리 등록 중
        case moving // 좌석 관리 - 앉은 자리 이동 중
        case cancelling // 좌석 관리 - 앉은 자리 취소 중
    }
}
