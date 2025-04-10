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

    let userUseCase: UserUseCase
    let coordinator: Coordinator

    private(set) var state = State()

    public init(userUseCase: UserUseCase, coordinator: Coordinator) {
        self.userUseCase = userUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .fadeOut:
            Task {
                // fadeout 전 딜레이
                try? await Task.sleep(for: .seconds(1))
                // fadeout (애니메이션 duration 0.5)
                self.state.isPresented = false
                // 딜레이 (애니메이션 duration 시간 확보)
                try? await Task.sleep(for: .seconds(1))

                self.action(.fadedOut)
            }
        case .fadedOut:
            // onboarding required status false로 설정하여 메인 앱 플로우로 전환
            userUseCase.setOnboardingRequiredStatus(false)
        }
    }
}
