//
//  PostView.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import SwiftUI

public struct PostView: View {
    @State private var viewModel: PostViewModel

    public init(viewModel: PostViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack {
            if viewModel.state.isLoading {
                Text("로딩 중입니다")
            } else if let errorMessage = viewModel.state.errorMessage {
                Text(errorMessage)
                Button("Reset") { withAnimation { viewModel.action(.onResetButtonTapped) } }
            } else if let title = viewModel.state.title, let content = viewModel.state.content {
                Text(title)
                Text(content)
                Button("Reset") { withAnimation { viewModel.action(.onResetButtonTapped) } }
            } else {
                Button("Fetch") { withAnimation { viewModel.action(.onFetchButtonTapped) } }
            }
            Button("sheet") { withAnimation { viewModel.action(.onSheetButtonTapped) } }
            Button("Next") { withAnimation { viewModel.action(.onNextButtonTapped) } }
        }
    }
}
