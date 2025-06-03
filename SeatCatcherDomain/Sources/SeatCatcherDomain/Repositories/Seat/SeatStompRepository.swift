//
//  SeatStompRepository.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/3/25.
//

import Foundation
import Combine

/// STOMP를 통해 좌석 데이터를 처리하는 리포지토리 인터페이스
public protocol SeatStompRepository {
    var trainCarPublisher: AnyPublisher<TrainCar, Error> { get }
    func subscribeToTrainCarSeats(trainCode: String)
    func unsubscribeFromTrainCarSeats(trainCode: String)
}
