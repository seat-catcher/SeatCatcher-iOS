//
//  CoordinatorImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SwiftUI
import SeatCatcherCore
import SeatCatcherPresentation

@Observable
final class AppCoordinator: Coordinator {
    var diContainer: DIContainer

    var path = NavigationPath()

    var sheet: (any AppRoute)?
    var appSheet: AppSheet? {
        get { sheet as? AppSheet }
        set { sheet = newValue }
    }
    var fullScreenCover: (any AppRoute)?
    var appFullScreenCover: AppFullScreenCover? {
        get { fullScreenCover as? AppFullScreenCover }
        set { fullScreenCover = newValue }
    }

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func buildScene(_ scene: AppScene) -> some View {
        switch scene {
        case .home:
            HomeView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
        switch sheet {
        case .home:
            HomeView()
        }
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
        switch fullScreenCover {
        case .home:
            HomeView()
        }
    }
}
