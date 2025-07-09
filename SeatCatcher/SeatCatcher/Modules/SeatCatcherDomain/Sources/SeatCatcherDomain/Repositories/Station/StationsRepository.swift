//
//  StationsRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/7/25.
//

public protocol StationsRepository: Sendable {
    func getStations(keyword: String, line: Int) async throws -> [Station]
    func getStationInfo(stationId: Int) async throws -> Station
}
