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
                appStore: diContainer.resolveAppStore(),
                kakaoLoginUseCase: diContainer.resolveKakaoLoginUseCase(),
                appleLoginUseCase: diContainer.resolveAppleLoginUseCase(),
                getUserInfoUseCase: diContainer.resolveGetUserInfoUseCase(),
                coordinator: self
            )
            LoginView(viewModel: loginViewModel)
        case .onboarding:
            let onboardingViewModel = OnboardingViewModel(coordinator: self)
            OnboardingView(viewModel: onboardingViewModel)
        case .userInfo:
            let userInfoViewModel = UserInfoViewModel(
                appStore: diContainer.resolveAppStore(),
                getRandomNicknameuseCase: diContainer.resolveGetRandomNicknameUseCase(),
                getRandomUserImageUseCase: diContainer.resolveGetRandomUserImageUseCase(),
                patchUserInfoUseCase: diContainer.resolvePatchUserInfoUseCase(),
                coordinator: self
            )
            UserInfoView(viewModel: userInfoViewModel)
        case .userGreeting:
            let userGreetingViewModel = UserGreetingViewModel(
                appStore: diContainer.resolveAppStore(),
                setOnboardingStatusUseCase: diContainer.resolveSetOnboardingStatusUseCase(),
                coordinator: self
            )
            UserGreetingView(viewModel: userGreetingViewModel)
        }
    }
}
