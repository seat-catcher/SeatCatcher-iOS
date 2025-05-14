//
//  PathHistoriesRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/13/25.
//

public protocol PathHistoriesRepository {
    func getPathHistories(cursor: Int?) async throws -> [PathHistory]
    func postPathHistories(departureStationId: Int, arrivalStationId: Int) async throws
}
