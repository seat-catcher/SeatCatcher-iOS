//
//  SeatRepository.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/18/25.
//

import Foundation

public protocol SeatRepository: Sendable {
    /// 열차 내 모든 구역의 좌석 정보를 모두 가져옵니다
    func getSeatsInTrainCar(trainCode: String, carCode: String) async throws -> TrainCar
    // MARK: - 좌석 상태 관리
    /// 좌석 정보 잠금을 해제합니다
    func unlockAllSeats() async throws
    /// 좌석 정보를 등록합니다
    func registerSeat(_ seat: Seat) async throws
    /// 좌석 정보를 취소합니다
    func cancelSeat() async throws
    // MARK: - 좌석 요청 관련
    /// 좌석요청자 - 요청
    func postRequestSeat(seatId: Int, creditAmount: Int) async throws
    /// 좌석요청자 - 요청 취소
    func cancelRequestSeat(seatId: Int, creditAmount: Int) async throws
    /// 좌석점유자 - 요청 수락
    func acceptRequestSeat(seatId: Int, requesterId: Int) async throws
    /// 좌석점유자 - 요청 거절
    func rejectRequestSeat(seatId: Int, requesterId: Int, creditAmount: Int) async throws
}
