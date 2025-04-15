//
//  MainFeatureView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/16/25.
//

import SwiftUI
import SeatCatcherCore

public struct MainFeatureView: View {
    @Environment(UserStore.self) private var userStore
    @State private var viewModel: MainFeatureViewModel

    public init(viewModel: MainFeatureViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        EmptyView()
    }
}
