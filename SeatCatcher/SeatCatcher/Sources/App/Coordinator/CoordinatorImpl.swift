//
//  CoordinatorImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SwiftUI
import SeatCatcherCore

@Observable
final class CoordinatorImpl: Coordinator {
    var diContainer: DIContainer

    var path = NavigationPath()

    var sheet: SeatCatcherCore.AppSheet?
    var fullScreenCover: SeatCatcherCore.AppFullScreenCover?

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func buildScene(_ scene: SeatCatcherCore.AppScene) -> some View {
        switch scene {
        case .post:
            let postViewModel = PostViewModel(
                postUseCase: diContainer.resolvePostUseCase(),
                coordinator: self
            )
            PostView(viewModel: postViewModel)
        case .next:
            NextView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: SeatCatcherCore.AppSheet) -> some View {
        switch sheet {
        case .post:
            PostSheetView()
        }
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: SeatCatcherCore.AppFullScreenCover) -> some View {
        switch fullScreenCover {
        case .post:
            PostFullScreenCoverView()
        }
    }

}


