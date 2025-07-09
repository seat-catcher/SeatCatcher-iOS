//
//  EndJourneyUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 6/5/25.
//

import Foundation

public protocol EndJourneyUseCase {
    func execute()
}

public final class EndJourneyUseCaseImpl: EndJourneyUseCase {
    private let pathHistoriesRepository: PathHistoriesRepository

    public init(pathHistoriesRepository: PathHistoriesRepository) {
        self.pathHistoriesRepository = pathHistoriesRepository
    }

    public func execute() {
        pathHistoriesRepository.unsubscribeAll()
    }
}
