//
//  PostRepositoryImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation
import Moya
import SeatCatcherDomain

final class PostRepositoryImpl: PostRepository {
    private let provider: MoyaProvider<PostAPI>

    init(provider: MoyaProvider<PostAPI>) {
        self.provider = provider
    }

    func fetchPost(byID id: Int) async throws -> Post {
        let requestDTO = PostRequestDTO(id: id)
        let response = try await provider.request(.getPost(requestDTO))
        let responseDTO = try JSONDecoder().decode(PostResponseDTO.self, from: response.data)
        return responseDTO.toEntity()
    }
}
