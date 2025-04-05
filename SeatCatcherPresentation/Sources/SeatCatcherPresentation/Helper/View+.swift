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

    func withNavigationBar(_ coordinator: Coordinator, isBackButtonHidden: Bool = false, title: String? = nil, withBorder: Bool = false) -> some View {
        VStack(spacing: 0) {
//            SCNavigationBar(coordinator, isBackButtonHidden: isBackButtonHidden, title: title, withBorder: withBorder)
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
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(Path(UIBezierPath(
            roundedRect: UIScreen.main.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath))
    }
    
    @ViewBuilder
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                Color(white: 0, opacity: 0.4)
                    .zIndex(1)
                    .ignoresSafeArea(.all)
                    .opacity(isPresented.wrappedValue ? 1 : 0)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented.wrappedValue)
        .sheet(isPresented: isPresented) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .presentationDetents([.height(height)])
                .ignoresSafeArea()
                .presentationBackgroundInteraction(.enabled)
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear)
        }
    }
    
    func loadCustomFonts() -> some View {
        Fonts.registerCustomFonts()
        return self
    }
}
