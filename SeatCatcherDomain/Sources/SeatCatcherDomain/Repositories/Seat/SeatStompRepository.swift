//
//  SeatStompRepository.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/3/25.
//

import Foundation
import Combine

public protocol SeatStompRepository {
    /// 열차 좌석 상태 퍼블리셔
    func trainCarPublisher(carCode: String) -> AnyPublisher<TrainCar, Error>
    /// STOMP 연결 상태 퍼블리셔
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    /// 열차 탑승 시 사용하는 함수
    func subscribeToTrainCarSeats(trainCode: String)
    func unsubscribeFromTrainCarSeats(trainCode: String)
    /// 좌석 요청 시 사용하는 함수
    func subscribeToSeatRequest(_ seat: Seat, requesterId: Int)
    func unsubscribeFromSeatRequest(_ seat: Seat, requesterId: Int)
    /// 좌석 점유 시 사용하는 함수
    func subscribeToSeatOccupied(_ seat: Seat)
    func unsubscribeFromSeatOccupied(_ seat: Seat)
}
