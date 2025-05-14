//
//  GetPathHistoriesUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/9/25.
//

public protocol GetPathHistoriesUseCase {
    func execute(cursor: Int?) async throws -> [PathHistory]
}

public final class GetPathHistoriesUseCaseImpl: GetPathHistoriesUseCase {
    private let pathHistoriesRepository: PathHistoriesRepository
    private let stationsReponsitory: StationsRepository

    public init(
        pathHistoriesRepository: PathHistoriesRepository,
        stationsRepository: StationsRepository
    ) {
        self.pathHistoriesRepository = pathHistoriesRepository
        self.stationsReponsitory = stationsRepository
    }

    /// - Parameters:
    ///   - cursor: 마지막 PathHistory의 Id를 넘기며, 첫 호출 시 nil을 넘깁니다.
    public func execute(cursor: Int?) async throws -> [PathHistory] {
        // 호선 정보 포함 X
        var pathHistories = try await pathHistoriesRepository.getPathHistories(cursor: cursor)
        // GET stations/{station_id}를 통해 호선 정보 매핑
        for (index, pathHistory) in pathHistories.enumerated() {
            let line = try await stationsReponsitory.getStationInfo(stationId: pathHistory.departureStationId).line
            pathHistories[index].line = line
        }
        return pathHistories
    }
}
