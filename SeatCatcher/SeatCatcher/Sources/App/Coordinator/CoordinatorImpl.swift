//
//  CoordinatorImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SwiftUI

@Observable
final class CoordinatorImpl: Coordinator {
    var path = NavigationPath()

    var sheet: AppSheet?
    var fullScreenCover: AppFullScreenCover?

    var sheetOnDismiss: (() -> Void)?
    var fullScreenCoverOnDismiss: (() -> Void)?

    @ViewBuilder
    func buildScene(_ scene: AppScene) -> some View {
        switch scene {
        case let .post(viewModel):
            PostView(viewModel: viewModel)
        case .next:
            NextView()
        }
    }

    @ViewBuilder
    func buildSheet(_ sheet: AppSheet) -> some View {
        switch sheet {
        case .post:
            PostSheetView()
        }
    }

    @ViewBuilder
    func buildFullScreenCover(_ fullScreenCover: AppFullScreenCover) -> some View {
        switch fullScreenCover {
        case .post:
            PostFullScreenCoverView()
        }
    }

}


