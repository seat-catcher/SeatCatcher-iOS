//
//  PostUseCase.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

protocol PostUseCase {
    func fetchPost(byID id: Int) async throws -> Post
}

final class PostUseCaseImpl: PostUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func fetchPost(byID id: Int) async throws -> Post {
        return try await repository.fetchPost(byID: id)
    }
}
