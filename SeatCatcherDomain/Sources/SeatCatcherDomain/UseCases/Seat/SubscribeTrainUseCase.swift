//
//  SubscribeTrainUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 6/4/25.
//

import Foundation
import Combine
import SeatCatcherDomain

public protocol SubscribeTrainUseCase {
    func execute(trainCode: String, carCode: String) -> AnyPublisher<TrainCar, Error>
    func connectionPublisher() -> AnyPublisher<Bool, Never>
    func unsubscribe(trainCode: String)
}

public final class SubscribeTrainUseCaseImpl: SubscribeTrainUseCase {
    private let seatStompRepository: SeatStompRepository
    
    public init(seatStompRepository: SeatStompRepository) {
        self.seatStompRepository = seatStompRepository
    }
    
    public func execute(trainCode: String, carCode: String) -> AnyPublisher<TrainCar, Error> {
        subscribe(trainCode: trainCode) // trainCode 단위 구독 (열차 전체)
        return seatStompRepository.trainCarPublisher(carCode: carCode) // 열차 -> 차량 필터링
    }
    
    public func connectionPublisher() -> AnyPublisher<Bool, Never> {
        seatStompRepository.isConnectedPublisher
    }
    
    private func subscribe(trainCode: String) {
        seatStompRepository.subscribeToTrainCarSeats(trainCode: trainCode)
    }
    
    public func unsubscribe(trainCode: String) {
        seatStompRepository.unsubscribeFromTrainCarSeats(trainCode: trainCode)
    }
}
