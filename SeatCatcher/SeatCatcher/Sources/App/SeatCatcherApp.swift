//
//  SeatCatcherApp.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/6/25.
//

import SwiftUI
import SeatCatcherCore
import SeatCatcherPresentation

@main
struct SeatCatcherApp: App {
    @State private var coordinator: CoordinatorImpl

    init() {
        let diContainer = DIContainerImpl()
        let coordinator = CoordinatorImpl(diContainer: diContainer)
        _coordinator = State(initialValue: coordinator)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.buildScene(.post)
                    .navigationDestination(for: SeatCatcherPresentation.AppScene.self) {
                        coordinator.buildScene($0)
                    }
                    .sheet(item: $coordinator.appSheet) {
                        coordinator.buildSheet($0)
                    }
                    .fullScreenCover(item: $coordinator.appFullScreenCover) {
                        coordinator.buildFullScreenCover($0)
                    }
            }
        }
    }
}
