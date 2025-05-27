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
        case backToSeatSectionPage // 좌석 구역 페이지로 이동
        case manageSeatSection(SeatSectionAction)
    }
    
    enum SeatSectionAction {
        case willSelectSeat(Seat) // 좌석 선택
        case willUnlockAllSeats // 좌석 정보 잠금 해제
    }
    
    // MARK: State Definition
    struct State {
        var trainCode: String // 열차 코드
        var carCode: String // 차량 코드
        var showNoInformationToast: Bool // 좌석 정보가 없어요 토스트 메시지 띄움 여부
        var userStatus: UserStatus // 유저의 선택 상황
        var seatSection: SeatSectionType // 현재 보고있는 구역
        var lookingCount: Int // 현재 열차 내 자리를 찾는 사용자 수, 0의 경우 띄우지 않음
        var seatSectionState: SeatSectionState
    }
    
    struct SeatSectionState {
        var selectedSeat: Seat? // 선택한 좌석
        var isBlocked: Bool // 좌석 정보 잠금 상태
        var seats: SeatSection // 좌석 정보
    }
    
    // MARK: Dependencies
    let store: AppStore
    let coordinator: Coordinator
    
    // MARK: States
    private(set) var state: State
    
    // MARK: UseCases
    // necessary
    private let getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase
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
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        registerSeatUseCase: RegisterSeatUseCase? = nil,
        moveSeatUseCase: MoveSeatUseCase? = nil,
        cancelSeatUseCase: CancelSeatUseCase? = nil,
        trainCode: String,
        carCode: String,
        userStatus: UserStatus
    ) {
        self.store = store
        self.coordinator = coordinator
        self.getSeatInTrainCarUseCase = getSeatInTrainCarUseCase
        self.getSeatInSectionUseCase = getSeatInSectionUseCase
        self.unlockSeatUseCase = unlockSeatUseCase
        self.registerSeatUseCase = registerSeatUseCase
        self.moveSeatUseCase = moveSeatUseCase
        self.cancelSeatUseCase = cancelSeatUseCase
        self.state = .init(
            trainCode: trainCode,
            carCode: carCode,
            showNoInformationToast: false, // 초깃값
            userStatus: userStatus,
            seatSection: .priority_A, // FIXME: 전역 관리 필요
            lookingCount: 10, // 초깃값
            seatSectionState: .init(
                selectedSeat: nil,
                isBlocked: false, // FIXME: 전역 관리 필요
                seats: .init(topSeats: [:], bottomSeats: [:])
            )
        )
    }
    
    
    // MARK: 기본
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        trainCode: String,
        carCode: String
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            trainCode: trainCode,
            carCode: carCode,
            userStatus: .standing
        )
    }
    
    // MARK: 좌석 등록하는 경우
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        registerSeatUseCase: RegisterSeatUseCase,
        trainCode: String,
        carCode: String
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            registerSeatUseCase: registerSeatUseCase,
            trainCode: trainCode,
            carCode: carCode,
            userStatus: .registering
        )
    }
    
    // MARK: 좌석 이동하는 경우
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        moveSeatUseCase: MoveSeatUseCase,
        trainCode: String,
        carCode: String
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            moveSeatUseCase: moveSeatUseCase,
            trainCode: trainCode,
            carCode: carCode,
            userStatus: .moving
        )
    }
    
    // MARK: 좌석 취소하는 경우
    public convenience init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        cancelSeatUseCase: CancelSeatUseCase,
        trainCode: String,
        carCode: String
    ) {
        self.init(
            store: store,
            coordinator: coordinator,
            getSeatInTrainCarUseCase: getSeatInTrainCarUseCase,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase,
            cancelSeatUseCase: cancelSeatUseCase,
            trainCode: trainCode,
            carCode: carCode,
            userStatus: .cancelling
        )
    }
    
    // MARK: action
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchSeatInSection()
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
        case .willCancelSeat:
            cancelSeat()
        case .backToSeatSectionPage:
            coordinator.pop()
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
                // 모든 구역의 좌석 데이터
                let trainCar = try await getSeatInTrainCarUseCase.execute(trainCode: state.trainCode, carCode: state.carCode)
                
                // 현재 구역의 좌석 데이터만 필터링
                state.seatSectionState.seats = try await getSeatInSectionUseCase.execute(trainCar: trainCar, seatSectionType: state.seatSection)
                
                // 본인이 앉고 있는 좌석을 선택상태로 처리
                if state.userStatus == .registering || state.userStatus == .moving {
                    state.seatSectionState.selectedSeat = state.seatSectionState.seats.topSeats.values.first { $0.isMySeat }
                    ?? state.seatSectionState.seats.bottomSeats.values.first { $0.isMySeat }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func registerSeat(_ seat: Seat) {
        /// 좌석 정보를 등록합니다
        if let registerSeatUseCase {
            Task {
                do {
                    try await registerSeatUseCase.execute(seat)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func moveSeat(_ seat: Seat) {
        /// 좌석 정보를 이동합니다
        if let moveSeatUseCase {
            Task {
                do {
                    try await moveSeatUseCase.execute(seat)
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
