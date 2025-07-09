//
//  PathHistoriesRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/13/25.
//

import Combine
import Foundation
import SeatCatcherDomain

public final class PathHistoriesRepositoryImpl: PathHistoriesRepository {
    private let networkService: NetworkService
    private let stompClientService: StompClientService

    public init(networkService: NetworkService, stompClientService: StompClientService) {
        self.networkService = networkService
        self.stompClientService = stompClientService
    }

    public func getPathHistories() async throws -> [PathHistory] {
        let response = try await networkService.getPathHistories()
        return response.domainModel
    }

    public func postPathHistories(departureStationId: Int, arrivalStationId: Int) async throws {
        try await networkService.postPathHistories(departureStationId: departureStationId, arrivalStationId: arrivalStationId)
    }

    public func startJourney(departureStationId: Int, arrivalStationId: Int, trainCode: String) async throws -> (pathHistoryId: Int, expectedArrivalTime: Date) {
        let response = try await networkService.postStartJourney(
            departureStationId: departureStationId,
            arrivalStationId: arrivalStationId,
            trainCode: trainCode
        )
        return response.domainModel
    }

    // FIXME: - 백엔드 이슈 해결 시 실제 구현으로 교체
    public func subscribeArrivalTime(pathHistoryId: Int) -> AnyPublisher<PathArrivalTime, Never> {
        let topic = "/topic/path-histories.\(pathHistoryId)"
        stompClientService.subscribe(topic: topic)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let arrivalTimePublisher = stompClientService
            .messagePublisher
            .compactMap { message -> PathArrivalTime? in
                dump(message)
                guard let data = message.text.data(using: .utf8),
                      let dto = try? JSONDecoder().decode(ArrivalTimeDTO.self, from: data),
                      let date = dateFormatter.date(from: dto.expectedArrivalTime)
                else { return nil }
                return PathArrivalTime(pathHistoryId: dto.pathHistoryId, expectedArrivalTime: date, arrived: dto.arrived)
            }
            .eraseToAnyPublisher()

        return arrivalTimePublisher
    }

    public func unsubscribeAll() {
        stompClientService.unsubscribeAll()
    }
}
