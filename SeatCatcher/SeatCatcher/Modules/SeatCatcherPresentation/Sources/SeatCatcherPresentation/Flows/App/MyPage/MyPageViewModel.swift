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
        let store: AppStore

        var isNotificationAllowed = true

        var userNickname: String { store.user.name }
        var userImage: UserImage { store.user.profileImage }
    }
    enum Action {
        case toggleNotification
        case logoutButtonTapped
        case withdrawalButtonTapped
        case didTapProfileChangeButton
        case termsButtonTapped
    }

    let store: AppStore
    private let logoutUseCase: LogoutUseCase
    let coordinator: Coordinator
    private(set) var state: State
    public init(store: AppStore, logoutUseCase: LogoutUseCase, coordinator: Coordinator) {
        self.store = store
        self.logoutUseCase = logoutUseCase
        self.coordinator = coordinator

        self.state = .init(store: store)
    }
    func action(_ action: Action) {
        switch action {
        case .toggleNotification:
            state.isNotificationAllowed.toggle()
        case .logoutButtonTapped:
            try? logoutUseCase.execute()
        case .withdrawalButtonTapped:
            try? logoutUseCase.execute()
        case .didTapProfileChangeButton:
            coordinator.push(AppScene.mypageProfileChange)
        case .termsButtonTapped:
            coordinator.push(AppScene.mypageTermsOfService)
        }
    }
}
