//
//  HomeView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import SwiftUI
import SeatCatcherCore

public struct HomeView: View {
    @State private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            UserInfoCardView()
        }
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .logoWithNotification(notificationButtonAction: {})
        )
    }
}

private struct UserInfoCardView: View {
    @Environment(AppStore.self) private var appStore
    var body: some View {
        Text(appStore.user.name)
    }
}

//#Preview {
//    HomeView()
//}
