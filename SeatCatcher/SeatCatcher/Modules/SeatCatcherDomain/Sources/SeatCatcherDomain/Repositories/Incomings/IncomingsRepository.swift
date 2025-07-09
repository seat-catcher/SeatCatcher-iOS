//
//  IncomingsRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/27/25.
//

public protocol IncomingsRepository {
    func getIncomings(departure: Station, arrival: Station) async throws -> [Incoming]
}
