//
//  GetIncomingsUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/27/25.
//

public protocol GetIncomingsUseCase {
    func execute(departure: Station, arrival: Station) async throws -> [Incoming]
}

public final class GetIncomingsUseCaseImpl: GetIncomingsUseCase {
    private let incomingsRepository: IncomingsRepository

    public init(incomingsRepository: IncomingsRepository) {
        self.incomingsRepository = incomingsRepository
    }

    public func execute(departure: Station, arrival: Station) async throws -> [Incoming] {
        let incomings = try await incomingsRepository.getIncomings(departure: departure, arrival: arrival)
        return incomings
    }
}
