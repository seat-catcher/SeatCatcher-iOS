//
//  View+.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/29/25.
//

import SwiftUI
import SeatCatcherCore

extension View {
    func withBackground(_ color: Color) -> some View {
        ZStack {
            color.ignoresSafeArea()
            self
        }
    }
    
    func withNavigationBar(_ coordinator: Coordinator, config: SCNavigationBar.SCNavigationBarConfig) -> some View {
        VStack(spacing: 0) {
            SCNavigationBar(coordinator, config: config)
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

    @ViewBuilder
    func alert(_ isPresented: Bool, alert: SCAlertView) -> some View {
        ZStack {
            self
            if isPresented {
                Color(.black.opacity(0.4)).ignoresSafeArea()
                alert
            }
        }
        .animation(.default, value: isPresented)
    }

    func loadCustomFonts() -> some View {
        Fonts.registerCustomFonts()
        return self
    }
}
