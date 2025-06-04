//
//  RejectRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석점유자 - 좌석 요청 거절 시 호출
public protocol CancelRequestSeatUseCase {
    func execute(seat: Seat, requesterId: Int, creditAmount: Int)
}
