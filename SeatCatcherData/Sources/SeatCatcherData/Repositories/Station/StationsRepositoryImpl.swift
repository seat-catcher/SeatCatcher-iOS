//
//  StationsRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/7/25.
//

import SeatCatcherDomain

public final class StationsRepositoryImpl: StationsRespotiory {
    private let networkService = NetworkService()

    public init() {}

    public func getStations(keyword: String, line: Int) async throws -> [Station] {
        let responseDTO = try await networkService.getStations(keyword: keyword, line: line)
        return responseDTO.map { $0.domainModel }
    }
}
