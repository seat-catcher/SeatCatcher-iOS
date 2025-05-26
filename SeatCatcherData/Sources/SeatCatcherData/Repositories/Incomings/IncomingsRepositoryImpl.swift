//
//  IncomingsRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/27/25.
//

import SeatCatcherDomain

public final class IncomingsRepositoryImpl: IncomingsRepository {
    private let networkService: NetworkService

    public init(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    public func getIncomings(departure: Station, arrival: Station) async throws -> [Incoming] {
        let line = String(departure.line)
        let responseDTO = try await networkService.getIncomings(departure: departure.name, arrival: arrival.name, line: line)
        return responseDTO.map { $0.domainModel }
    }
}
