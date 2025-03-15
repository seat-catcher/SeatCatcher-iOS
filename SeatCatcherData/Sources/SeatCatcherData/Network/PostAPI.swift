//
//  PostAPI.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation
import Moya

/// API 엔드포인트가 정의된 열거형입니다.
enum PostAPI {
    case getPost(_ requestDTO: PostRequestDTO)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        .init(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case let .getPost(request): 
            return "/posts/\(request.id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPost:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPost:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let base = ["Content-type": "application/json"]

        switch self {
        case .getPost:
            return base
        }
    }

    var sampleData: Data {
        switch self {
        case .getPost:
            do {
                return try JSONEncoder().encode(PostResponseDTO.stub())
            } catch {
                fatalError("Stub 인코딩 실패: \(error.localizedDescription)")
            }
        }
    }

}
