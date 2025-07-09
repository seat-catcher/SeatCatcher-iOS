//
//  UserGreetingViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 4/10/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class UserGreetingViewModel: ViewModel {
    struct State {
        var isPresented = true
    }

    enum Action {
        case fadeOut
        case fadedOut
    }

    let user: User
    let appStore: AppStore
    let coordinator: Coordinator

    private(set) var state = State()

    public init(
        user: User,
        appStore: AppStore,
        coordinator: Coordinator
    ) {
        self.user = user
        self.appStore = appStore
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .fadeOut:
            Task {
                // fadeout 전 딜레이
                try? await Task.sleep(for: .seconds(1.5))
                // fadeout (애니메이션 duration 0.5)
                self.state.isPresented = false
                // 딜레이 (애니메이션 duration 시간 확보)
                try? await Task.sleep(for: .seconds(1))

                self.action(.fadedOut)
                appStore.setUser(user)
            }
        case .fadedOut:
            // AppStore에 User 정보 전달 -> user.hasOnBoarded가 true로 전환되며 메인 플로우 시작
            appStore.setUser(user)
        }
    }
}
