//
//  SeatCatcherApp.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/6/25.
//

import SwiftUI
import Moya

@main
struct SeatCatcherApp: App {
    @State private var coordinator: CoordinatorImpl
    @State private var diContainer: DIContainerImpl

    init() {
        let coordinator = CoordinatorImpl()
        _coordinator = State(initialValue: coordinator)
        _diContainer = State(initialValue: DIContainerImpl(coordinator: coordinator))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.buildScene(.post(diContainer.injectPostViewModel()))
                    .navigationDestination(for: AppScene.self) {
                        coordinator.buildScene($0)
                    }
                    .sheet(item: $coordinator.sheet) {
                        coordinator.buildSheet($0)
                    }
                    .fullScreenCover(item: $coordinator.fullScreenCover) {
                        coordinator.buildFullScreenCover($0)
                    }
            }
        }
    }
}
