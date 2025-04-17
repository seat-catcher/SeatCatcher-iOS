//
//  SeatCatcherApp.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/6/25.
//

import SwiftUI

import SeatCatcherCore
import SeatCatcherPresentation
import SeatCatcherDomain

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct SeatCatcherApp: App {
    // 앱 화면 전환을 담당하는 Coordinator
    @State private var appCoordinator: AppCoordinator
    @State private var onboardingCoordinator: OnboardingCoordinator

    // 유저 상태 저장을 위한 값
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isOnboardingRequired") private var isOnboardingRequired = true

    // 의존성 주입을 위한 DIContainer
    private let diContainer: DIContainerImpl

    // 유저 상태 저장을 위한 Store
    @State private var appStore: AppStore

    // 유저 상태 기반으로 present할 flow를 선택하는 computed property
    private var currentFlow: AppFlow {
        if isSignedIn {
            if isOnboardingRequired { .onboarding }
            else { .authenticated }
        }
        else { .unauthenticated }
    }

    init() {
        // DIContainer 인스턴스 생성
        self.diContainer = DIContainerImpl()

        // AppStore @State 프로퍼티 초기화
        self._appStore = State(initialValue: diContainer.resolveAppStore())

        // Coordinator 인스턴스 생성
        let appCoordinator = AppCoordinator(diContainer: diContainer)
        let onboardingCoordinator = OnboardingCoordinator(diContainer: diContainer)
        _appCoordinator = State(initialValue: appCoordinator)
        _onboardingCoordinator = State(initialValue: onboardingCoordinator)

        // Kakao App Key를 통해 Kakao SDK 초기화
        guard let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String
        else { fatalError("Kakao Native App Key를 불러올 수 없습니다.") }
        KakaoSDK.initSDK(appKey: kakaoAppKey)

//         Presentation 모듈 Resource의 폰트 등록
        Fonts.registerCustomFonts()

        // AccessToken 유효성 검사 후 invalid시 reissue
        // authenticated 상태일 시 유저 정보 fetch
        initialAuthandUserSetUp()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch currentFlow {
                case .authenticated:
                    NavigationStack(path: $appCoordinator.path) {
                        appCoordinator.buildScene(.home)
                            .navigationDestination(for: AppScene.self) {
                                appCoordinator.buildScene($0)
                            }
                            .sheet(item: $appCoordinator.appSheet, onDismiss: appCoordinator.sheetOnDismiss) {
                                appCoordinator.buildSheet($0)
                            }
                            .fullScreenCover(item: $appCoordinator.appFullScreenCover, onDismiss: appCoordinator.fullScreenCoverOnDismiss) {
                                appCoordinator.buildFullScreenCover($0)
                            }
                    }
                case .onboarding:
                    NavigationStack(path: $onboardingCoordinator.path) {
                        onboardingCoordinator.buildScene(.onboarding)
                            .navigationDestination(for: OnboardingScene.self) { onboardingCoordinator.buildScene($0) }
                    }
                case .unauthenticated:
                    NavigationStack(path: $onboardingCoordinator.path) {
                        onboardingCoordinator.buildScene(.login)
                            .navigationDestination(for: OnboardingScene.self) { onboardingCoordinator.buildScene($0) }
                    }
                }
            }
            .onOpenURL { handleURL($0) }
            .environment(appStore)
        }
    }
}

extension SeatCatcherApp {
    private func handleURL(_ url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            // SDK는 AppDelegate의 openURL 메서드에서 Bool 값을 반환하도록 설계되어 있지만,
            // SwiftUI App 구조에서는 해당 반환값이 필요하지 않으므로 무시합니다.
            _ = AuthController.handleOpenUrl(url: url)
        }
    }

    private func initialAuthandUserSetUp() {
        let authUseCase = diContainer.resolveAuthUseCase()
        let userUseCase = diContainer.resolveUserUseCase()

        Task {
            await checkLoginStatus(authUseCase: authUseCase)
            await setAppStore(userUseCase: userUseCase)
        }
    }

    private func checkLoginStatus(authUseCase: AuthUseCase) async {
        do {
            try await authUseCase.isAccessTokenValid()
        } catch {
            try? authUseCase.logout()
        }
    }

    private func setAppStore(userUseCase: UserUseCase) async {
        guard currentFlow == .authenticated,
        let user = try? await userUseCase.getUserInfo() else { return }

        self.appStore.user = user
    }
}


enum AppFlow {
    case authenticated, onboarding, unauthenticated
}
