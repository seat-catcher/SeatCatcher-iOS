//
//  PathHistoriesRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/13/25.
//

import SeatCatcherDomain

public final class PathHistoriesRepositoryImpl: PathHistoriesRepository {
    private let networkService: NetworkService

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    public func postPathHistories(departureStationId: Int, arrivalStationId: Int) async throws {
        try await networkService.postPathHistories(departureStationId: departureStationId, arrivalStationId: arrivalStationId)
    }
}
