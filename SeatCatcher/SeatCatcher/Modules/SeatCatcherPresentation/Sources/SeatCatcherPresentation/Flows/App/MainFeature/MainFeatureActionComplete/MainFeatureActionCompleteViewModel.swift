//
//  MainFeatureActionCompleteViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 6/12/25.
//

import Foundation
import SwiftUI
import SeatCatcherCore
import SeatCatcherDomain
import Combine

@Observable
public final class MainFeatureActionCompleteViewModel: ViewModel {
    struct State {
        var actionCase: MainFeatureActionCase
    }
    
    struct Config {
        let iconImage: ImageResource
        let title: String
        let subtitle: String
        let hasUnderline: Bool
        let buttonTitle: String?
    }
    
    public enum MainFeatureActionCase {
        case unlockedSeat(creditAmount: Int) // 좌석 정보 잠금 해제
        case requestInProcess(stationName: String, seat: Seat, creditAmount: Int) // 요청 중
        case requestAccepted(stationName: String, creditAmount: Int) // 좌석 요청이 수락됨
        case requestRejected // 좌석 요청이 거절됨
        case sendCredit(creditAmount: Int) // 좌석을 양보 받은 후 크레딧 전달
        case receivedCreditByYield(creditAmount: Int) // 좌석 양보로 크레딧 지급
        case receivedCreditByRegister(creditAmount: Int) // 좌석 정보 입력 크레딧 지급
        case takeBackCreditByCancel(creditAmount: Int) // 좌석 정보 입력 크레딧 회수
        
        var config: Config {
            switch self {
            case let .unlockedSeat(creditAmount):
                return Config(
                    iconImage: .iconSeat,
                    title: "좌석정보\n획득 완료!",
                    subtitle: "\(creditAmount) 크레딧이 차감되었어요.",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case let .requestInProcess(stationName, _, _):
                return Config(
                    iconImage: .dangerCircle, // 실제로 쓰지 않고 로티 사용
                    title: "요청 중",
                    subtitle: "\(stationName)역을 지난 뒤부터\n좌석을 바꿀 수 있어요",
                    hasUnderline: false,
                    buttonTitle: "요청 취소하기"
                )
            case let .requestAccepted(stationName, _):
                return Config(
                    iconImage: .iconAccept,
                    title: "요청이 수락됐어요",
                    subtitle: "\(stationName)역을 지난 뒤부터\n좌석을 바꿀 수 있어요",
                    hasUnderline: false,
                    buttonTitle: "확인"
                )
            case .requestRejected:
                return Config(
                    iconImage: .iconReject,
                    title: "요청이 거절됐어요",
                    subtitle: "수락 여부와 관계없이\n크레딧은 소모됩니다.",
                    hasUnderline: true,
                    buttonTitle: "확인"
                )
            case let .sendCredit(creditAmount):
                return Config(
                    iconImage: .iconSeat,
                    title: "\(creditAmount) 크레딧을 전달했어요",
                    subtitle: "편안하고 쾌적한 이동 되세요!",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case let .receivedCreditByYield(creditAmount):
                return Config(
                    iconImage: .iconCreditPlus,
                    title: "\(creditAmount) 크레딧을\n받았어요",
                    subtitle: "크레딧스토어에서 받은 크레딧을 확인해보세요!",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case let .receivedCreditByRegister(creditAmount):
                return Config(
                    iconImage: .iconCreditPlus,
                    title: "\(creditAmount) 크레딧을\n받았어요",
                    subtitle: "크레딧스토어에서 받은 크레딧을 확인해보세요!",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case let .takeBackCreditByCancel(creditAmount):
                return Config(
                    iconImage: .iconCreditMinus,
                    title: "\(creditAmount) 크레딧이\n회수됐어요",
                    subtitle: "등록 후, 5분 내 취소 시 리워드는 회수됩니다.",
                    hasUnderline: true,
                    buttonTitle: nil
                )
            }
        }
    }
    
    enum Action {
        case willAppear
        case willDismiss
    }
    
    let store: AppStore
    let coordinator: Coordinator // 양보 요청에 대한 응답 건
    let receiveSeatUseCase: ReceiveSeatUseCase
    let cancelRequestSeatUseCase: CancelRequestSeatUseCase
    private var cancellables: Set<AnyCancellable> = []

    private(set) var state: State
    
    @MainActor
    public init(store: AppStore, coordinator: Coordinator, actionCase: MainFeatureActionCase, receiveSeatUseCase: ReceiveSeatUseCase, cancelRequestSeatUseCase: CancelRequestSeatUseCase) {
        self.store = store
        self.coordinator = coordinator
        self.state = .init(actionCase: actionCase)
        self.receiveSeatUseCase = receiveSeatUseCase
        self.cancelRequestSeatUseCase = cancelRequestSeatUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .willDismiss:
            switch state.actionCase {
            case .receivedCreditByYield:
                coordinator.popLast(1)
            case let .requestInProcess(_, seat, creditAmount):
                cancelSeatRequest(seat, requesterId: store.user.id, creditAmount: creditAmount) // 좌석 요청 취소
                coordinator.popLast(2)
            case let .requestAccepted(_, creditAmount):
                coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .sendCredit(creditAmount: creditAmount)))
            case .unlockedSeat:
                coordinator.popLast(2)
            case .takeBackCreditByCancel,.receivedCreditByRegister, .requestRejected:
                coordinator.popLast(3)
            case .sendCredit:
                coordinator.popLast(4)
            }
        case .willAppear:
            if case let .requestInProcess(stationName, seat, creditAmount) = state.actionCase {
                observeRequestee(stationName: stationName, seat: seat, creditAmount: creditAmount)
            }
        }
    }
    
    @MainActor
    private func observeRequestee(stationName: String, seat: Seat, creditAmount: Int) {
        /// 좌석 요청 응답(자)  퍼블리셔
        store.seatRequesteePublisher
            .sink { [weak self] requestee in
                guard let self else { return }
                if let requestee = requestee {
                    if requestee.isAccepted {
                        Task {
                            let publisher =  try await receiveSeatUseCase.execute(seat, requesterId: store.user.id, creditAmount: creditAmount)
                            store.subscribeToSeatRequesterPublisher(publisher, seatId: seat.id)
                            coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .requestAccepted(stationName: stationName, creditAmount: creditAmount)))
                        }
                    } else {
                        coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .requestRejected))
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
    
    private func cancelSeatRequest(_ seat: Seat, requesterId: Int, creditAmount: Int) {
        Task { [cancelRequestSeatUseCase] in
            try await cancelRequestSeatUseCase.execute(seat, requesterId: requesterId, creditAmount: creditAmount)
        }
    }
}
