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

    // FIXME: - 실제 구현으로 교체
    // TODO: - response createdDate string 포맷 정의 시, mm.dd 형태로 가공
    /// PathHistory 생성 API가 아직 구현되지 않아, Fake PathHistory 배열을 리턴합니다.
    public func getPathHistories(cursor: Int?) async throws -> [PathHistory] {
//        let response = try await networkService.getPathHistories(cursor: cursor)
//        return response.domainModel
        let fakePathHistories = (0..<10).map {
            PathHistory(
                id: $0,
                line: 2,
                departureStationId: 1704,
                departureStationName: "사당",
                arrivalStationId: 1715,
                arrivalStationName: "당산",
                createdDate: "09.23"
            )
        }
        return fakePathHistories
    }

    public func postPathHistories(departureStationId: Int, arrivalStationId: Int) async throws {
        try await networkService.postPathHistories(departureStationId: departureStationId, arrivalStationId: arrivalStationId)
    }
}
