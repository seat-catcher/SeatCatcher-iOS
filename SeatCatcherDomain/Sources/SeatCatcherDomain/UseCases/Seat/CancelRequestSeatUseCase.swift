//
//  CancelRequestSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation

/// 좌석요청자 - 좌석 요청 취소 시 호출
public protocol CancelRequestSeatUseCase {
    func execute(seat: Seat, creditAmount: Int)
}
