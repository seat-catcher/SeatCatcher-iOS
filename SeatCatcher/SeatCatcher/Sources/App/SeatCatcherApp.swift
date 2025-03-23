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
    @State private var coordinator: CoordinatorImpl

    init() {
        let diContainer = DIContainerImpl()
        let coordinator = CoordinatorImpl(diContainer: diContainer)
        _coordinator = State(initialValue: coordinator)

        let kakaoAppKey = "701b881b47dfc78148747d07a98421f2"
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }

    var body: some Scene {
        WindowGroup {
            // TODO: - 자동로그인 로직 작성
            // - UserDefaults에 로그인된 상태인지 여부 isSignedIn: Bool 저장 / 해당 값으로 플로우 분기
            // - 앱 시작 시 액세스토큰으로 로그인 시도
            //   - 성공 시 액세스토큰 / 리프레시토큰 키체인 저장 및 isSignedIn = true
            //   - 401 날라오면 리프레시토큰으로 토큰 갱신 시도
            //   - 리프레시토큰도 401 날라오면 isSignedIn = false

            // TODO: - 플로우 분기
            // - 온보딩 플로우 및 유저 플로우 구축
            // - 로그인 여부 isSignedIn: Bool / 온보딩 여부 isOnboardingNeeded: Bool 유저디폴트 저장
            // - 온보딩 필요 시 온보딩 플로우 첫 뷰로
            // - 온보딩 완료했으나 로그인 상태 아닐시 온보딩 플로우 내 로그인 뷰에서 플로우 시작
            // - 로그인 상태이면 유저 플로우로
            NavigationStack(path: $coordinator.path) {
                coordinator.buildScene(.post)
                    .navigationDestination(for: AppScene.self) { coordinator.buildScene($0) }
                    .sheet(item: $coordinator.appSheet) { coordinator.buildSheet($0) }
                    .fullScreenCover(item: $coordinator.appFullScreenCover) { coordinator.buildFullScreenCover($0) }
                    .onOpenURL { handleURL($0) }
            }
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
