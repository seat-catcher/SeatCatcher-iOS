//
//  PostView.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import SwiftUI

struct PostView: View {
    private var viewModel: PostViewModel

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

            case .loading:
                Text("로딩 중입니다")
                    .padding()

            case .loaded(let post):
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

            case .error(let message):
                VStack(spacing: 16) {
                    Text(message)
                        .foregroundColor(.red)
                    Button("Reset") {
                        viewModel.action(.onResetButtonTapped)
                    }
                    .padding()
                }
            }
        }
    }
}
