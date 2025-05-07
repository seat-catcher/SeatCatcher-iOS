//
//  SearchArrivalStationsUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/7/25.
//

public protocol SearchArrivalStationsUseCase {
    func execute(keyword: String, line: Int) async throws -> [Station]
}

public final class SearchArrivalStationsUseCaseImpl: SearchArrivalStationsUseCase {
    private let stationsRepository: StationsRespotiory

    public init(stationsRepository: StationsRespotiory) {
        self.stationsRepository = stationsRepository
    }

    public func execute(keyword: String, line: Int) async throws -> [Station] {
        let stations = try await stationsRepository.getStations(keyword: keyword, line: line)
        return stations
    }
}
