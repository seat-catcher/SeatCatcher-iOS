//
//  SearchDepartureStationsUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/7/25.
//

public protocol SearchDepartureStationsUseCase {
    func execute(keyword: String) async throws -> [Station]
}

public final class SearchDepartureStationsUseCaseImpl: SearchDepartureStationsUseCase {
    private let stationsRepository: StationsRespotiory

    public init(stationsRepository: StationsRespotiory) {
        self.stationsRepository = stationsRepository
    }

    public func execute(keyword: String) async throws -> [Station] {
        var stations = try await stationsRepository.getStations(keyword: keyword, line: 2)
        stations += try await stationsRepository.getStations(keyword: keyword, line: 7)
        return stations
    }
}
