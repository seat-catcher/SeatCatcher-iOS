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
        var seatSection: SeatSection
        var lookingCount: Int
    }

    let appStore: AppStore
    let coordinator: Coordinator
    private(set) var seatSectionViewModel: SeatSectionViewModel
    private(set) var state: State

    public init(appStore: AppStore, coordinator: Coordinator, isBlocked: Bool, getSeatInSectionUseCase: GetSeatInSectionUseCase, unlockSeatUseCase: UnlockSeatUseCase, seatSection: SeatSection, lookingCount: Int) {
        self.appStore = appStore
        self.coordinator = coordinator
        self._seatSectionViewModel = .init(
            appStore: appStore,
            isBlocked: isBlocked,
            getSeatInSectionUseCase: getSeatInSectionUseCase,
            unlockSeatUseCase: unlockSeatUseCase
        )
        self.state = .init(seatSection: seatSection, lookingCount: lookingCount)
    }

    func action(_ action: Action) {

    }
}

public enum SeatSection: String {
    case priority_A = "교통약자구역 A"
    case normal_A = "일반구역 A"
    case normal_B = "일반구역 B"
    case normal_C = "일반구역 C"
    case priority_B = "교통약자구역 B"
}
