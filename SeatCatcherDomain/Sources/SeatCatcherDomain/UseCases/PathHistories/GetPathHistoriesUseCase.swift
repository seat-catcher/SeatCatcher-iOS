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
        let pathHistories = try await pathHistoriesRepository.getPathHistories(cursor: cursor)
        return pathHistories
    }
}
