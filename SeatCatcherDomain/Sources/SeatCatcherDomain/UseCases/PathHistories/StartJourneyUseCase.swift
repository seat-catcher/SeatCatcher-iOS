//
//  StartJourneyUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 6/1/25.
//

import Foundation

public protocol StartJourneyUseCase {
    func execute(departure: Station, arrival: Station, trainCode: String) async throws -> Int
}

public final class StartJourneyUseCaseImpl: StartJourneyUseCase {
    private let pathHistoriesRepository: PathHistoriesRepository

    public init(pathHistoriesRepository: PathHistoriesRepository) {
        self.pathHistoriesRepository = pathHistoriesRepository
    }

    public func execute(departure: Station, arrival: Station, trainCode: String) async throws -> Int {
        let pathHistoriesID = try await pathHistoriesRepository.startJourney(
            departureStationId: departure.id,
            arrivalStationId: arrival.id,
            trainCode: trainCode
        )
        return pathHistoriesID
    }
}
