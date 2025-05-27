//
//  MainFeatureViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/16/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@MainActor
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
        case willCancelSeat // 좌석 취소
        case willGoToNearestAvailableSection // 좌석 정보가 있는 가장 가까운 구역으로 이동
        case manageSeatSection(SeatSectionAction)
    }
    
    enum SeatSectionAction {
        case willSelectSeat(Seat) // 좌석 선택
        case willUnlockAllSeats // 좌석 정보 잠금 해제
    }
    
    // MARK: State Definition
    struct State {
        var nearestAvailableSection: SeatSectionType? // 가장 가까운 좌석 데이터, 띄우지 않을 땐 nil
        var userStatus: UserStatus // 유저의 선택 상황
        var seatSection: SeatSectionType // 현재 보고있는 구역
        var lookingCount: Int // 현재 열차 내 자리를 찾는 사용자 수, 0의 경우 띄우지 않음
        var seatSectionState: SeatSectionState
    }
    
    struct SeatSectionState {
        var selectedSeat: Seat? // 선택한 좌석
        var isBlocked: Bool // 좌석 정보 잠금 상태
        var seats: (topSeats: [Seat], bottomSeats: [Seat]) // 좌석 정보
    }
    
    // MARK: Dependencies
    let store: AppStore
    let coordinator: Coordinator
    
    // MARK: States
    private(set) var state: State
    
    // MARK: UseCases
    // necessary
    private let getSeatInSectionUseCase: GetSeatInSectionUseCase
    private let unlockSeatUseCase: UnlockSeatUseCase
    // optional
    private let registerSeatUseCase: RegisterSeatUseCase?
    private let moveSeatUseCase: MoveSeatUseCase?
    private let cancelSeatUseCase: CancelSeatUseCase?
    
    
    // MARK: Initialize
    public init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        registerSeatUseCase: RegisterSeatUseCase? = nil,
        moveSeatUseCase: MoveSeatUseCase? = nil,
        cancelSeatUseCase: CancelSeatUseCase? = nil,
        userStatus: UserStatus
    ) {
        self.store = store
        self.coordinator = coordinator
        self.getSeatInSectionUseCase = getSeatInSectionUseCase
        self.unlockSeatUseCase = unlockSeatUseCase
        self.registerSeatUseCase = registerSeatUseCase
        self.moveSeatUseCase = moveSeatUseCase
        self.cancelSeatUseCase = cancelSeatUseCase
        self.state = .init(
            nearestAvailableSection: nil, // 초깃값
            userStatus: userStatus,
            seatSection: .normal_A, // FIXME: 전역 관리 필요
            lookingCount: 0, // 초깃값
            seatSectionState: .init(
                selectedSeat: nil,
                isBlocked: false, // FIXME: 전역 관리 필요
                seats: (topSeats: [], bottomSeats: [])
            )
        )
    }
    
    
    // MARK: 기본
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            userStatus: .standing
        )
    }
    
    // MARK: 좌석 등록하는 경우
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        registerSeatUseCase: RegisterSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            registerSeatUseCase: registerSeatUseCase,
            userStatus: .registering
        )
    }
    
    // MARK: 좌석 이동하는 경우
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        moveSeatUseCase: MoveSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            moveSeatUseCase: moveSeatUseCase,
            userStatus: .moving
        )
    }
    
    // MARK: 좌석 취소하는 경우
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        cancelSeatUseCase: CancelSeatUseCase
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            cancelSeatUseCase: cancelSeatUseCase,
            userStatus: .cancelling
        )
    }
    
    // MARK: action
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchSeatInSection()
        case .manageSeatSection(let seatSectionAction):
            handleSeatSectionAction(seatSectionAction)
        case .backButtonDidTap:
            coordinator.pop()
        case .homeButtonDidTap:
            coordinator.popToRoot()
        case .manageMySeatButtonDidTap:
            coordinator.push(AppScene.manageSeat)
        case .willRegisterSeat:
            registerSeat()
        case .willMoveSeat:
            moveSeat()
        case .willCancelSeat:
            cancelSeat()
        case .willGoToNearestAvailableSection:
            coordinator.pop() // FIXME: 유저 플로우 검토 필요
        }
    }
    
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
    
    private func fetchSeatInSection() {
        Task {
            do {
                state.seatSectionState.seats = try await getSeatInSectionUseCase.execute()
                if self.state.userStatus == .registering || self.state.userStatus == .moving {
                    self.state.seatSectionState.selectedSeat
                    = state.seatSectionState.seats.topSeats.first(
                        where: { $0.isSeated }
                    )
                    ?? state.seatSectionState.seats.bottomSeats.first(
                        where: { $0.isSeated }
                    )
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func registerSeat() {
        /// 좌석 정보를 등록합니다
        if let registerSeatUseCase {
            Task {
                do {
                    try await registerSeatUseCase.execute()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func moveSeat() {
        /// 좌석 정보를 이동합니다
        if let moveSeatUseCase {
            Task {
                do {
                    try await moveSeatUseCase.execute()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func cancelSeat() {
        /// 좌석 정보를 취소합니다
        if let cancelSeatUseCase {
            Task {
                do {
                    try await cancelSeatUseCase.execute()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public enum UserStatus {
        case seated // 착석 중
        case standing // 자리 찾는 중
        case registering // 좌석 관리 - 앉은 자리 등록 중
        case moving // 좌석 관리 - 앉은 자리 이동 중
        case cancelling // 좌석 관리 - 앉은 자리 취소 중
    }
}
