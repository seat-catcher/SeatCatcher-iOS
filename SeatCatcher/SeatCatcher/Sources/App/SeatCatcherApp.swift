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
            VStack {
                NavigationStack(path: $coordinator.path) {
                    coordinator.buildScene(.post)
                        .navigationDestination(for: AppScene.self) {
                            coordinator.buildScene($0)
                        }
                        .sheet(item: $coordinator.appSheet) {
                            coordinator.buildSheet($0)
                        }
                        .fullScreenCover(item: $coordinator.appFullScreenCover) {
                            coordinator.buildFullScreenCover($0)
                        }
                        .onOpenURL {
                            if AuthApi.isKakaoTalkLoginUrl($0) {
                                _ = AuthController.handleOpenUrl(url: $0)
                            }
                        }
                }
            }
        }
    }
}
