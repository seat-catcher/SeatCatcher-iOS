//
//  SeatRepository.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/18/25.
//

import Foundation

public protocol SeatRepository: Sendable {
    // 열차 내 모든 구역의 좌석 정보를 모두 가져옵니다
    func getSeatsInTrainCar(trainCode: String, carCode: String) async throws -> TrainCar
    // 좌석 정보 잠금을 해제합니다
    func unlockAllSeats() async throws
    // 좌석 정보를 등록합니다
    func registerSeat(_ seat: Seat) async throws
    // 좌석 정보를 이동합니다
    func moveSeat(_ seat: Seat) async throws
    // 좌석 정보를 취소합니다
    func cancelSeat() async throws
}
