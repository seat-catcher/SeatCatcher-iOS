//
//  SeatCatcherApp.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/6/25.
//

import SwiftUI
import Moya

@main
struct SeatCatcherApp: App {
    var body: some Scene {
        WindowGroup {
            let postRepository = PostRepositoryImpl(provider: MoyaProvider<PostAPI>())
            let postUseCase = PostUseCaseImpl(repository: postRepository)
            let postViewModel = PostViewModel(postUseCase: postUseCase)
            PostView(viewModel: postViewModel)
        }
    }
}
