//
//  SeatCatcherDataError.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 5/28/25.
//

import Foundation

enum SeatCatcherDataError: Error {
    case InvalidSeatSectionType // 구역 파싱 오류
    case FailedToGetRowCount // 좌석 개수 파싱 오류
    case InvalidSeatType // 좌석 타입 파싱 오류
    case nullValue // 빈 데이터 수신 오류
    
    var description: String {
        switch self {
        case .InvalidSeatSectionType: "구역 파싱 오류"
        case .FailedToGetRowCount: "좌석 개수 파싱 오류"
        case .InvalidSeatType: "좌석 타입 파싱 오류"
        case .nullValue: "빈 데이터 수신 오류"
        }
    }
}
