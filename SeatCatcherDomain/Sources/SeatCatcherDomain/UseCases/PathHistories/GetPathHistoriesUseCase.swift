//
//  GetPathHistoriesUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/9/25.
//

import Foundation

public protocol GetPathHistoriesUseCase {
    func execute(cursor: Int?) async throws -> [PathHistory]
}

public final class GetPathHistoriesUseCaseImpl: GetPathHistoriesUseCase {
    private let pathHistoriesRepository: PathHistoriesRepository
    private let stationsRepository: StationsRepository

    public init(
        pathHistoriesRepository: PathHistoriesRepository,
        stationsRepository: StationsRepository
    ) {
        self.pathHistoriesRepository = pathHistoriesRepository
        self.stationsRepository = stationsRepository
    }

    /// - Parameters:
    ///   - cursor: 마지막 PathHistory의 Id를 넘기며, 첫 호출 시 nil을 넘깁니다.
    public func execute(cursor: Int?) async throws -> [PathHistory] {
//        // 호선 정보 포함 X
//        var pathHistories = try await pathHistoriesRepository.getPathHistories(cursor: cursor)
//        // GET stations/{station_id}를 통해 호선 정보 매핑
//        for (index, pathHistory) in pathHistories.enumerated() {
//            let line = try await stationsReponsitory.getStationInfo(stationId: pathHistory.departureStationId).line
//            pathHistories[index].line = line
//        }
//        return pathHistories

        let initialPathHistories = try await pathHistoriesRepository.getPathHistories(cursor: nil)

        // TaskGroup을 통해 네트워크 요청 병렬 처리
        let pathHistories = await withTaskGroup(of: PathHistory.self) { group in

            for pathHistory in initialPathHistories {

                // addTask
                group.addTask { [stationsRepository] in

                    // 각 pathHistory에 Line 정보 추가
                    var pathHistory = pathHistory
                    pathHistory.line = try? await stationsRepository.getStationInfo(stationId: pathHistory.departureStationId).line
                    return pathHistory
                }
            }

            var pathHistories = [PathHistory]()

            // taskgroup에서 Line 정보가 추가된 pathHistory 반환
            for await pathHistory in group { pathHistories.append(pathHistory) }
            // 순서가 보장되지 않으므로, id순으로 재정렬
            pathHistories.sort { $0.id > $1.id }

            return pathHistories
        }

        return pathHistories
    }
}
