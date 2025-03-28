//
//  View+.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/29/25.
//

import SwiftUI
import SeatCatcherCore

extension View {
    func withBackground() -> some View {
        ZStack { self }
        .background(.black)
        .background(ignoresSafeAreaEdges: .all)
    }

    func withNavigationBar(_ coordinator: Coordinator, isBackButtonHiden: Bool = false, title: String? = nil, withBorder: Bool = false) -> some View {
        VStack(spacing: 0) {
            SCNavigationBar(coordinator, isBackButtonHiden: isBackButtonHiden, title: title, withBorder: withBorder)
            self
        }
    }

    @ViewBuilder
    func applyToolbarVisibility(_ visibility: Visibility, for bar: ToolbarPlacement) -> some View {
        if #available(iOS 18.0, *) {
            self.toolbarVisibility(visibility, for: bar)
        } else {
            self.toolbar(visibility, for: bar)
        }
    }
}
