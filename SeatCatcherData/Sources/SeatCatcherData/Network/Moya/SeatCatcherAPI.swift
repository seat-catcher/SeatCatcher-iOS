//
//  SeatCatcherAPI.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/20/25.
//

import Foundation
import Moya

enum SeatCatcherAPI {
    case postSignInWithApple(_ requestDTO: AppleLoginRequestDTO)
}

extension SeatCatcherAPI: TargetType {
    var baseURL: URL {
        .init(string: "https://api.seatcatcher.site")!
    }
    
    var path: String {
        switch self {
        case .postSignInWithApple:
            return "/user/authenticate/apple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSignInWithApple:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .postSignInWithApple(requestDTO):
            .requestParameters(
                parameters: [
                    "provider": "LOCAL",
                    "identityToken": requestDTO.identityToken
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String : String]? {
        let base = ["Content-type": "application/json"]

        switch self {
        case .postSignInWithApple:
            return base
        }
    }
}
