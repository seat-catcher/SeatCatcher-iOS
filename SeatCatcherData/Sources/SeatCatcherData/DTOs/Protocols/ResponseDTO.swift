//
//  ResponseDTOProtocol.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

/// Reponse DTO 구현 요구 사항을 정의한 프로토콜입니다.
protocol ResponseDTO: Codable {
    associatedtype DomainModel

    /// 테스트용 Stub 인스턴스 리턴
    static func stub() -> Self

    /// DTO -> Entity 매핑
    func toDomainModel() -> DomainModel
}
