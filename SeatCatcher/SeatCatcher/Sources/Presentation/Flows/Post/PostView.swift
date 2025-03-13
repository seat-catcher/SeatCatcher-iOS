//
//  PostView.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import SwiftUI

struct PostView: View {
    private let viewModel: PostViewModel

    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                Button("Fetch") {
                    viewModel.action(.onFetchButtonTapped)
                }
                .padding()

            case .isLoading:
                Text("로딩 중입니다")
                    .padding()

            case .isLoaded(let post):
                VStack(spacing: 16) {
                    Text(post.title)
                        .font(.title)
                    Text(post.content)
                        .font(.body)
                    Button("Reset") {
                        viewModel.action(.onResetButtonTapped)
                    }
                    .padding()
                }

            case .isErrorOccurred(let message):
                VStack(spacing: 16) {
                    Text(message)
                        .foregroundColor(.red)
                    Button("Reset") {
                        viewModel.action(.onResetButtonTapped)
                    }
                    .padding()
                }
            }
            Button("Next") {
                viewModel.action(.isNextButtonTapped)
            }
            Button("Sheet") {
                viewModel.action(.isSheetButtonTapped)
            }
        }
    }
}
