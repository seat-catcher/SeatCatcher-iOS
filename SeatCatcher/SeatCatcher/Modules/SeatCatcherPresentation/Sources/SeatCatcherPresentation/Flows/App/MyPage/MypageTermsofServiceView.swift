//
//  MypageTermsofServiceView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 7/3/25.
//

import SwiftUI
import SeatCatcherCore

public struct MypageTermsofServiceView: View {
    
    let coordinator: Coordinator
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        ZStack {
            if let url = URL(string: "https://woongaaaa.notion.site/SeatCatcher-21f1a839ca3c80868ea4d2a264b40be4?source=copy_link") {
                WebView(url: url)
            }
        }
        .withNavigationBar(
            coordinator,
            config: .title(
                title: "약관 및 정책",
                backButtonAction: nil,
                applyDefaultPopAction: true
            )
        )
    }
}
