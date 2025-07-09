//
//  SubscribePathHistoryUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 6/1/25.
//

import Combine
import Foundation

public protocol SubscribeArrivalTimeUseCase {
    func execute(pathHistoryId: Int) -> AnyPublisher<PathArrivalTime, Never>
}

public final class SubscribeArrivalTimeUseCaseImpl: SubscribeArrivalTimeUseCase {
    private let pathHistoriesRepository: PathHistoriesRepository

    public init(pathHistoriesRepository: PathHistoriesRepository) {
        self.pathHistoriesRepository = pathHistoriesRepository
    }
    
    public func execute(pathHistoryId: Int) -> AnyPublisher<PathArrivalTime, Never> {
        let publisher = pathHistoriesRepository.subscribeArrivalTime(pathHistoryId: pathHistoryId)
        return publisher
    }
}
