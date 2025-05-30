//
//  SeatCatcherAPI.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/20/25.
//

import Foundation
import Moya

enum SeatCatcherAPI: Sendable {
    case getAccessTokenValidStatus

    case postSignInWithApple(requestDTO: AppleLoginRequestDTO)
    case postSignInWithKakao(requestDTO: KakaoLoginRequestDTO)
    case postRefreshToken(requestDTO: RefreshTokenRequestDTO)

    case getUser
    case patchUser(requestDTO: PatchUserRequestDTO)

    case getStations(requestDTO: GetStationsRequestDTO)
    case getStationInfo(stationId: Int)

    case getPathHistories(cursor: Int?)
    case postPathHistories(requestDTO: PostPathHistoriesRequestDTO)

    case getSeatInfo(trainCode: String, carCode: String)
    
    case postRegisterSeat(requestDTO: PostRegisterSeatRequestDTO)
    case deleteSeat

    case getIncomings(requestDTO: GetIncomingsRequestDTO)
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
        case let .getStationInfo(stationId):
            return "/stations/\(stationId)"
        case .getPathHistories:
            return "/path-histories"
        case .postPathHistories:
            return "/path-histories"
        case .getSeatInfo:
            return "/trains"
        case .postRegisterSeat:
            return "/user/seats"
        case .deleteSeat:
            return "/user/seats"
        case .getIncomings:
            return "/trains/incomings"
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
        case .getStationInfo:
            return .get
        case .getPathHistories:
            return .get
        case .postPathHistories:
            return .post
        case .getSeatInfo:
            return .get
        case .postRegisterSeat:
            return .post
        case .deleteSeat:
            return .delete
        case .getIncomings:
            return .get
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
        case let .patchUser(requestDTO):
            return .requestJSONEncodable(requestDTO)
        case let .getStations(requestDTO):
            let parameters: [String: Any] = [
                "keyword": requestDTO.keyword,
                "line": requestDTO.line,
                "order": requestDTO.order
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getStationInfo:
            return .requestPlain
        case let .getPathHistories(cursor):
            var parameters: [String: Any] = [ "size": 10 ]
            if let cursor = cursor { parameters.merge(["cursor": cursor]) { _, new in new } }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .postPathHistories(requestDTO):
            return .requestJSONEncodable(requestDTO)
        case let .getSeatInfo(trainCode, carCode):
            return .requestParameters(parameters: ["trainCode": trainCode, "carCode": carCode], encoding: URLEncoding.default)
        case let .postRegisterSeat(requestDTO):
            return .requestJSONEncodable(requestDTO)
        case .deleteSeat:
            return .requestPlain
        case let .getIncomings(requestDTO):
            let parameters: [String: Any] = [
                "lineNumber": requestDTO.lineNumber,
                "dep": requestDTO.dep,
                "dest": requestDTO.dest
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        var accessToken: String { (try? KeychainService.get(key: "accessToken")) ?? "" }

        let base = ["Content-type": "application/json"]
        let baseWithAuth = [
            "Content-type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]

        switch self {
        case .getAccessTokenValidStatus:
            return baseWithAuth
        case .postSignInWithApple:
            return base
        case .postSignInWithKakao:
            return base
        case .postRefreshToken:
            return base
        case .getUser:
            return baseWithAuth
        case .patchUser:
            return baseWithAuth
        case .getStations:
            return baseWithAuth
        case .getStationInfo:
            return baseWithAuth
        case .getPathHistories:
            return baseWithAuth
        case .postPathHistories:
            return baseWithAuth
        case .getSeatInfo:
            return baseWithAuth
        case .postRegisterSeat:
            return baseWithAuth
        case .deleteSeat:
            return baseWithAuth
        case .getIncomings:
            return baseWithAuth
        }
    }

    var validationType: ValidationType { .successCodes }
}
