//
//  SeatCatcherAPI.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/20/25.
//

import Foundation
import Moya

enum SeatCatcherAPI: Sendable {
    case getAccessTokenValidStatus(_ accessToken: String)

    case postSignInWithApple(_ requestDTO: AppleLoginRequestDTO)
    case postSignInWithKakao(_ requestDTO: KakaoLoginRequestDTO)
    case postRefreshToken(_ requestDTO: RefreshTokenRequestDTO)

    case getUser(accessToken: String)
    case patchUser(_ requestDTO: PatchUserRequestDTO, accessToken: String)

    case getStations(requestDTO: GetStationsRequestDTO, accessToken: String)

    case postPathHistories(requestDTO: PostPathHistoriesRequestDTO, accessToken: String)
}

extension SeatCatcherAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.dev.seatcatcher.site") else {
            fatalError("Base URL이 올바르지 않습니다.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getAccessTokenValidStatus:
            return "/token/validate"
        case .postSignInWithApple:
            return "/user/authenticate/apple"
        case .postSignInWithKakao:
            return "/user/authenticate/kakao"
        case .postRefreshToken:
            return "/token/refresh"
        case .getUser:
            return "/user/me"
        case .patchUser:
            return "/user/me"
        case .getStations:
            return "/stations"
        case .postPathHistories:
            return "/path-histories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAccessTokenValidStatus:
            return .get
        case .postSignInWithApple:
            return .post
        case .postSignInWithKakao:
            return .post
        case .postRefreshToken:
            return .post
        case .getUser:
            return .get
        case .patchUser:
            return .patch
        case .getStations:
            return .get
        case .postPathHistories:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAccessTokenValidStatus:
            return .requestPlain
        case let .postSignInWithApple(requestDTO):
            return .requestJSONEncodable(requestDTO)
        case let .postSignInWithKakao(requestDTO):
            return .requestJSONEncodable(requestDTO)
        case let .postRefreshToken(requestDTO):
            return .requestJSONEncodable(requestDTO)
        case .getUser:
            return .requestPlain
        case let .patchUser(requestDTO, _):
            return .requestJSONEncodable(requestDTO)
        case let .getStations(requestDTO, _):
            let parameters: [String: Any] = [
                "keyword": requestDTO.keyword,
                "line": requestDTO.line,
                "order": requestDTO.order
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .postPathHistories(requestDTO, _):
            return .requestJSONEncodable(requestDTO)
        }
    }

    var headers: [String : String]? {
        let base = ["Content-type": "application/json"]

        switch self {
        case let .getAccessTokenValidStatus(accessToken):
            let auth = ["Authorization": "Bearer \(accessToken)"]
            return base.merging(auth) { _, new in new }
        case .postSignInWithApple:
            return base
        case .postSignInWithKakao:
            return base
        case .postRefreshToken:
            return base
        case let .getUser(accessToken):
            let auth = ["Authorization": "Bearer \(accessToken)"]
            return base.merging(auth) { _, new in new }
        case let .patchUser(_, accessToken):
            let auth = ["Authorization": "Bearer \(accessToken)"]
            return base.merging(auth) { _, new in new }
        case let .getStations(_, accessToken):
            let auth = ["Authorization": "Bearer \(accessToken)"]
            return base.merging(auth) { _, new in new }
        case let .postPathHistories(_, accessToken):
            let auth = ["Authorization": "Bearer \(accessToken)"]
            return base.merging(auth) { _, new in new }
        }
    }

    var validationType: ValidationType { .successCodes }
}
