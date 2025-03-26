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

@main
struct SeatCatcherApp: App {
    @State private var appCoordinator: AppCoordinator
    @State private var onboardingCoordinator: OnboardingCoordinator
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isOnboardingRequired") private var isOnboardingRequired = true

    private var currentFlow: AppFlow {
        if isSignedIn { isOnboardingRequired ? .onboarding : .authenticated }
        else { .unauthenticated }
    }

    init() {
        let diContainer = DIContainerImpl()
        let appCoordinator = AppCoordinator(diContainer: diContainer)
        let onboardingCoordinator = OnboardingCoordinator(diContainer: diContainer)

        _appCoordinator = State(initialValue: appCoordinator)
        _onboardingCoordinator = State(initialValue: onboardingCoordinator)

        guard let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String
        else { fatalError("Kakao Native App Key를 불러올 수 없습니다.") }
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }

    var body: some Scene {
        WindowGroup {
            Button("isSignedIn true") { UserDefaults.standard.set(true, forKey: "isSignedIn") }
            Button("isSignIn false") { UserDefaults.standard.set(false, forKey: "isSignedIn") }
            Button("isOnboardingRequired true") { UserDefaults.standard.set(true, forKey: "isOnboardingRequired") }
            Button("isOnboardingRequired false") { UserDefaults.standard.set(false, forKey: "isOnboardingRequired") }
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
                            .navigationDestination(for: OnboardingScene.self) { onboardingCoordinator.buildScene($0)
                            }
                    }
                case .unauthenticated:
                    NavigationStack(path: $onboardingCoordinator.path) {
                        onboardingCoordinator.buildScene(.login)
                            .navigationDestination(for: OnboardingScene.self) { onboardingCoordinator.buildScene($0)
                            }
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
}


enum AppFlow {
    case authenticated, onboarding, unauthenticated
}
