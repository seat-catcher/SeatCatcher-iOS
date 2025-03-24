//
//  PostRepository.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

public protocol PostRepository {
    func fetchPost(byID id: Int) async throws -> Post
}
