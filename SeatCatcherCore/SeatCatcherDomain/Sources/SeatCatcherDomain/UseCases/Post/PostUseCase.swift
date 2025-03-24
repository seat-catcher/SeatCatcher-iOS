//
//  PostUseCase.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

public protocol PostUseCase {
    func fetchPost(byID id: Int) async throws -> Post
}

public final class PostUseCaseImpl: PostUseCase {
    private let repository: PostRepository

    public init(repository: PostRepository) {
        self.repository = repository
    }

    public func fetchPost(byID id: Int) async throws -> Post {
        return try await repository.fetchPost(byID: id)
    }
}
