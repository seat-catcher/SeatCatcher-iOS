//
//  GetStationUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 6/3/25.
//

public protocol GetStationUseCase {
    func execute(id: Int) async throws -> Station
}

public final class GetStationUseCaseImpl: GetStationUseCase {
    private let stationsRepository: StationsRepository

    public init(stationsRepository: StationsRepository) {
        self.stationsRepository = stationsRepository
    }

    public func execute(id: Int) async throws -> Station {
        let station = try await stationsRepository.getStationInfo(stationId: id)
        return station
    }
}
