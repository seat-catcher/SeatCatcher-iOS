//
//  PathHistoriesRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/13/25.
//

import Combine
import Foundation

public protocol PathHistoriesRepository {
    func getPathHistories() async throws -> [PathHistory]
    func postPathHistories(departureStationId: Int, arrivalStationId: Int) async throws
    func startJourney(departureStationId: Int, arrivalStationId: Int, trainCode: String) async throws -> (pathHistoryId: Int, expectedArrivalTime: Date)
    func subscribeArrivalTime(pathHistoryId: Int) -> AnyPublisher<Date, Never>
}
