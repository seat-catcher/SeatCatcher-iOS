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
        case requestInProcess(stationName: String, seat: Seat) // 요청 중
        case requestAccepted(stationName: String) // 좌석 요청이 수락됨
        case requestRejected // 좌석 요청이 거절됨
        case sendCredit(creditAmount: Int) // 좌석을 양보 받은 후 크레딧 전달
        case receivedCreditByYield(creditAmount: Int) // 좌석 양보로 크레딧 지급
        case receivedCreditByRegister(creditAmount: Int) // 좌석 정보 입력 크레딧 지급
        case takeBackCreditByCancel(creditAmount: Int) // 좌석 정보 입력 크레딧 회수
        
        var config: Config {
            switch self {
            case .unlockedSeat(let creditAmount):
                return Config(
                    iconImage: .iconSeat,
                    title: "좌석정보\n획득 완료!",
                    subtitle: "\(creditAmount) 크레딧이 차감되었어요.",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case .requestInProcess(let stationName):
                return Config(
                    iconImage: .dangerCircle,
                    title: "요청 중",
//                    subtitle: "상대방의 요청을 기다리고 있어요",
                    // FIXME: TEMP
                    subtitle: "\(stationName)역을 지난 뒤부터\n좌석을 바꿀 수 있어요",
                    hasUnderline: false,
                    buttonTitle: "요청 취소하기"
                )
            case .requestAccepted(let stationName):
                return Config(
                    iconImage: .iconAccept,
                    title: "요청이 수락됐어요",
                    // FIXME: TEMP
//                    subtitle: "이제 자리에 앉을 수 있어요",
                    subtitle: "\(stationName)역을 지난 뒤부터\n좌석을 바꿀 수 있어요",
                    hasUnderline: false,
                    buttonTitle: "확인"
                )
            case .requestRejected:
                return Config(
                    iconImage: .iconReject,
                    title: "요청이 거절됐어요",
                    // FIXME: TEMP
                    subtitle: "다른 자리를 다시 요청할 수 있어요",
//                    subtitle: "수락 여부와 관계없이\n크레딧은 소모됩니다.",
                    hasUnderline: true,
                    buttonTitle: "확인"
                )
            case .sendCredit(let creditAmount):
                return Config(
                    iconImage: .iconSeat,
                    title: "\(creditAmount) 크레딧을 전달했어요",
                    subtitle: "편안하고 쾌적한 이동 되세요!",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case .receivedCreditByYield(let creditAmount):
                return Config(
                    iconImage: .iconCreditPlus,
                    title: "\(creditAmount) 크레딧을\n받았어요",
                    subtitle: "크레딧스토어에서 받은 크레딧을 확인해보세요!",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case .receivedCreditByRegister(let creditAmount):
                return Config(
                    iconImage: .iconCreditPlus,
                    title: "\(creditAmount) 크레딧을\n받았어요",
                    subtitle: "크레딧스토어에서 받은 크레딧을 확인해보세요!",
                    hasUnderline: false,
                    buttonTitle: nil
                )
            case .takeBackCreditByCancel(let creditAmount):
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
    private var cancellables: Set<AnyCancellable> = []

    private(set) var state: State
    
    @MainActor
    public init(store: AppStore, coordinator: Coordinator, actionCase: MainFeatureActionCase, receiveSeatUseCase: ReceiveSeatUseCase) {
        self.store = store
        self.coordinator = coordinator
        self.state = .init(actionCase: actionCase)
        self.receiveSeatUseCase = receiveSeatUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .willDismiss:
            switch state.actionCase {
            case .sendCredit, .receivedCreditByYield:
                coordinator.popLast(1) // FIXME: 코디네이터 애니메이션 필요
            case .unlockedSeat, .requestInProcess:
                coordinator.popLast(2) // FIXME: 코디네이터 애니메이션 필요
            case .requestAccepted, .requestRejected, .takeBackCreditByCancel,.receivedCreditByRegister:
                coordinator.popLast(3) // FIXME: 코디네이터 애니메이션 필요
            }
        case .willAppear:
            if case let .requestInProcess(stationName, seat) = state.actionCase {
                observeRequestee(stationName: stationName, seat: seat)
            }
        }
    }
    
    @MainActor
    private func observeRequestee(stationName: String, seat: Seat) {
        /// 좌석 요청 응답(자)  퍼블리셔
        store.seatRequesteePublisher
            .sink { [weak self] requestee in
                guard let self else { return }
                if let requestee = requestee {
                    if requestee.isAccepted {
                        Task {
                            let publisher =  try await receiveSeatUseCase.execute(seat, requesterId: store.user.id, creditAmount: 10) // FIXME: 크레딧 수 수정
                            store.subscribeToSeatRequesterPublisher(publisher, seatId: seat.id)
                            coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .requestAccepted(stationName: stationName)))
                        }
                    } else {
                        coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .requestRejected))
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
}
