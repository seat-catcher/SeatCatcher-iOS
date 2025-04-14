//
//  HomeView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import SwiftUI
import SeatCatcherCore

public struct HomeView: View {
    @Environment(UserStore.self) private var userStore
    @State private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        Text(userStore.user.name)
        Image(userStore.user.profileImage.image)
        Button("change") {
            viewModel.changeUserImage()
        }
    }
}

//#Preview {
//    HomeView()
//}
