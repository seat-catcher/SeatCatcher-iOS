//
//  MyPageViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 6/5/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class MyPageViewModel: ViewModel {
    struct State {
        var isNotificationAllowed = true
    }
    enum Action {
        case toggleNotification
        case logoutButtonTapped
        case withdrawalButtonTapped
    }

    let appStore: AppStore
    private let logoutUseCase: LogoutUseCase
    let coordinator: Coordinator
    private(set) var state = State()
    public init(appStore: AppStore, logoutUseCase: LogoutUseCase, coordinator: Coordinator) {
        self.appStore = appStore
        self.logoutUseCase = logoutUseCase
        self.coordinator = coordinator
    }
    func action(_ action: Action) {
        switch action {
        case .toggleNotification:
            state.isNotificationAllowed.toggle()
        case .logoutButtonTapped:
            try? logoutUseCase.execute()
        case .withdrawalButtonTapped:
            try? logoutUseCase.execute()
        }
    }
}
