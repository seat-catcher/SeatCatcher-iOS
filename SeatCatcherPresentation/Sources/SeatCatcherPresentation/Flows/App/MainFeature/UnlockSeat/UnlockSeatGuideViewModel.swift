//
//  UnlockSeatGuideViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 6/12/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class UnlockSeatGuideViewModel: ViewModel {
    struct State { }
    
    enum Action {
        case unlockSeat
        case willDismiss
    }
    
    private let store: AppStore
    private let coordinator: Coordinator
    
    private let unlockSeatUseCase: UnlockSeatUseCase
    
    private(set) var state = State()
    
    public init(store: AppStore, coordinator: Coordinator, unlockSeatUseCase: UnlockSeatUseCase) {
        self.store = store
        self.coordinator = coordinator
        self.unlockSeatUseCase = unlockSeatUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .unlockSeat:
            /// 좌석 정보를 잠금 해제합니다
            Task {
                do {
                    try await unlockSeatUseCase.execute(creditAmount: -10, targetUserId: store.user.id) // FIXME: 크레딧 액수 수정
                    await MainActor.run {
                        store.isBlocked = false
                        coordinator.push(AppScene.mainFeatureActionComplete(actionCase: .unlockedSeat(creditAmount: 10)))
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        case .willDismiss:
            coordinator.pop()
        }
    }
}
