//
//  SubscribeTrainUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation
import Combine

public protocol SubscribeTrainUseCase {
    func execute(trainCode: String, carCode: String) -> AnyPublisher<TrainCar, Error>
    func unsubscribe(trainCode: String)
}

public final class SubscribeTrainUseCaseImpl: SubscribeTrainUseCase {
    private let seatStompRepository: SeatStompRepository
    
    public init(seatStompRepository: SeatStompRepository) {
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(trainCode: String, carCode: String) -> AnyPublisher<TrainCar, Error> {
        seatStompRepository.subscribeToTrainCarSeats(trainCode: trainCode) // trainCode 단위 구독 (열차 전체)
        return seatStompRepository.trainCarPublisher(trainCode: trainCode, carCode: carCode) // 열차 -> 차량 필터링
    }
    
    public func unsubscribe(trainCode: String) {
        seatStompRepository.unsubscribeFromTrainCarSeats(trainCode: trainCode)
    }
}
