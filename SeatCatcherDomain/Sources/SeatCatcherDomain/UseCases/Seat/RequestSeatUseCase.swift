//
//  RequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석요청자 - 좌석 요청 시 호출
public protocol RequestSeatUseCase {
    func execute(seat: Seat, creditAmount: Int)
}
