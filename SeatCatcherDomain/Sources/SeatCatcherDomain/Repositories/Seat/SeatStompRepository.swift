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
    func trainCarPublisher(trainCode: String, carCode: String) -> AnyPublisher<TrainCar, Error>
    /// 좌석 점유자 - 좌석 요청자 정보 퍼블리셔
    func getSeatRequesterPublisher() -> AnyPublisher<SeatRequester, Error>
    /// 좌석 요청자 - 좌석 점유자 응답 퍼블리셔
    func getSeatRequesteePublisher() -> AnyPublisher<SeatRequestee, Error>
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
