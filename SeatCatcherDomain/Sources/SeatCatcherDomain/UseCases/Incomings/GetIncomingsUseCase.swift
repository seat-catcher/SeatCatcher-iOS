//
//  GetIncomingsUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/27/25.
//

public protocol GetIncomingsUseCase {
    func execute(arrival: Station, departure: Station) async throws -> [Incoming]
}

public final class GetIncomingsUseCaseImpl: GetIncomingsUseCase {
    private let repository: IncomingsRepository

    public init(repository: IncomingsRepository) {
        self.repository = repository
    }

    public func execute(arrival: Station, departure: Station) async throws -> [Incoming] {
        let incomings = try await repository.getIncomings(departure: departure, arrival: arrival)
        return incomings
    }
}
