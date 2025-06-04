//
//  GetPathHistoriesUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/9/25.
//

import Foundation

public protocol GetPathHistoriesUseCase {
    func execute() async throws -> [PathHistory]
}

public final class GetPathHistoriesUseCaseImpl: GetPathHistoriesUseCase {
    private let pathHistoriesRepository: PathHistoriesRepository

    public init(pathHistoriesRepository: PathHistoriesRepository) {
        self.pathHistoriesRepository = pathHistoriesRepository
    }

    public func execute() async throws -> [PathHistory] {
        let pathHistories = try await pathHistoriesRepository.getPathHistories()
        return pathHistories
    }
}
