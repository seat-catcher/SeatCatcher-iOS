//
//  StationsRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/7/25.
//

import SeatCatcherDomain

public final class StationsRepositoryImpl: StationsRepository {
    private let networkService: NetworkService

    public init(networkService: NetworkService) {
        self.networkService = networkService
    }

    public func getStations(keyword: String, line: Int) async throws -> [Station] {
        let responseDTO = try await networkService.getStations(keyword: keyword, line: line)
        return responseDTO.map { $0.domainModel }
    }
}
