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
    enum Action {
        case seatSectionDidTap(SeatSectionViewModel.Action)
        case backButtonDidTap
        case homeButtonDidTap
        case manageMySeatButtonDidTap
    }

    struct State {
        var userStatus: MainFeatureUserStatus // 유저의 상황 대분류
        var seatSection: SeatSection // 좌석 정보
        var lookingCount: Int // 좌석 찾고있는 사람 수
    }

    let appStore: AppStore
    let coordinator: Coordinator
    private(set) var seatSectionViewModel: SeatSectionViewModel
    private(set) var state: State

    public init(
        appStore: AppStore,
        coordinator: Coordinator,
        isBlocked: Bool,
        getSeatInSectionUseCase: GetSeatInSectionUseCase,
        unlockSeatUseCase: UnlockSeatUseCase,
        seatSection: SeatSection,
        lookingCount: Int
    ) {
        self.appStore = appStore
        self.coordinator = coordinator
        self._seatSectionViewModel = .init(
            appStore: appStore,
            isBlocked: isBlocked,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase
        )
        self.state = .init(userStatus: .standing, seatSection: seatSection, lookingCount: lookingCount)
    }
    
    
    
    
    func action(_ action: Action) {
        
    }
}

public enum MainFeatureUserStatus {
    case seated // 착석 중
    case standing // 자리 찾는 중
    case selecting // 좌석 관리 - 앉은 자리 선택 중
    case cancelling // 좌석 관리 - 앉은 자리 취소 중
}
