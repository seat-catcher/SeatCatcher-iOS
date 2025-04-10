//
//  OnboardingCoordinator.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/26/25.
//

import Foundation
import SwiftUI
import SeatCatcherCore
import SeatCatcherPresentation

@Observable
final class OnboardingCoordinator: Coordinator {
    var diContainer: DIContainer

    var path = NavigationPath()

    var sheet: (any AppRoute)?
    var fullScreenCover: (any AppRoute)?

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func buildScene(_ scene: OnboardingScene) -> some View {
        switch scene {
        case .login:
            let loginViewModel = LoginViewModel(
                authUseCase: diContainer.resolveAuthUseCase(),
                coordinator: self
            )
            LoginView(viewModel: loginViewModel)
        case .onboarding:
            let onboardingViewModel = OnboardingViewModel(
                userUseCase: diContainer.resolveUserUseCase(),
                coordinator: self
            )
            OnboardingView(viewModel: onboardingViewModel)
        case .userInfo:
            let userInfoViewModel = UserInfoViewModel(
                userUseCase: diContainer.resolveUserUseCase(),
                coordinator: self
            )
            UserInfoView(viewModel: userInfoViewModel)
        case let .userGreeting(user):
            let userGreetingViewModel = UserGreetingViewModel(
                user: user,
                userUseCase: diContainer.resolveUserUseCase(),
                coordinator: self
            )
            UserGreetingView(viewModel: userGreetingViewModel)
        }
    }
}
