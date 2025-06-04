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
    public func subscribeArrivalTime(pathHistoryId: Int) -> AnyPublisher<Date, Never> {
        let topic = "/topic/path-histories.\(pathHistoryId)"
        stompClientService.subscribe(topic: topic)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        let arrivalTimePublisher = stompClientService
            .messagePublisher
            .filter { $0.destination == topic }
            .compactMap { message -> Date? in
                guard let data = message.text.data(using: .utf8),
                      let dto = try? JSONDecoder().decode(ArrivalTimeDTO.self, from: data)
                else { return nil }

                let date = dateFormatter.date(from: dto.expectedArrivalTime)
                dump(date)
                return date
            }
            .eraseToAnyPublisher()

        return arrivalTimePublisher
//        return makeMockArrivalTimePublisher()
    }

    /// 5초마다 `Date`를 발행하다가 15분이 지나면 자동으로 완료하는 퍼블리셔를 리턴합니다.
    private func makeMockArrivalTimePublisher() -> AnyPublisher<Date, Never> {
        let now = Date()
        let initialExpectedArrival = now.addingTimeInterval(60 * 15)

        let timer = Timer
            .publish(every: 5.0, on: .main, in: .common)
            .autoconnect()

        let publisher = timer
            .map { _ -> Date in
                return initialExpectedArrival.addingTimeInterval((0...5).compactMap { Double($0) }.randomElement()! )
            }
            .prefix(180)
            .eraseToAnyPublisher()

        return publisher
    }
}
