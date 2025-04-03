//
//  SeatCatcherApp.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/6/25.
//

import SwiftUI
import SeatCatcherCore
import SeatCatcherPresentation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import SeatCatcherData
import SeatCatcherDomain

@main
struct SeatCatcherApp: App {
    @State private var appCoordinator: AppCoordinator
    @State private var onboardingCoordinator: OnboardingCoordinator
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isOnboardingRequired") private var isOnboardingRequired = true
    @AppStorage("isUserInfoRequired") private var isUserInfoRequired = true

    private let diContainer = DIContainerImpl()

    private var currentFlow: AppFlow {
        if isSignedIn {
            if isOnboardingRequired { .onboarding }
            else if isUserInfoRequired { .userInfoRequired }
            else { .authenticated }
        }
        else { .unauthenticated }
    }

    init() {
        let appCoordinator = AppCoordinator(diContainer: diContainer)
        let onboardingCoordinator = OnboardingCoordinator(diContainer: diContainer)

        _appCoordinator = State(initialValue: appCoordinator)
        _onboardingCoordinator = State(initialValue: onboardingCoordinator)

        guard let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String
        else { fatalError("Kakao Native App Key를 불러올 수 없습니다.") }
        KakaoSDK.initSDK(appKey: kakaoAppKey)

        checkLoginStatus()
    }

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            HStack {
                Button("로그인") {
                    UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "isSignedIn"), forKey: "isSignedIn")
                }
                Button("온보딩") {
                    UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "isOnboardingRequired"), forKey: "isOnboardingRequired")
                }
                Button("정보 입력") {
                    UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "isUserInfoRequired"), forKey: "isUserInfoRequired")
                }
            }
            #endif
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
                case .userInfoRequired:
                    NavigationStack(path: $onboardingCoordinator.path) {
                        onboardingCoordinator.buildScene(.generateName)
                            .navigationDestination(for: OnboardingScene.self) { onboardingCoordinator.buildScene($0) }
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

    private func checkLoginStatus() {
        let authUseCase = diContainer.resolveAuthUseCase()
        Task {
            do {
                try await authUseCase.isAccessTokenValid()
            } catch {
                do {
                    try authUseCase.logout()
                } catch {
                    fatalError("로그아웃 실패")
                }
            }
        }
    }
    
}


enum AppFlow {
    case authenticated, userInfoRequired, onboarding, unauthenticated
}
