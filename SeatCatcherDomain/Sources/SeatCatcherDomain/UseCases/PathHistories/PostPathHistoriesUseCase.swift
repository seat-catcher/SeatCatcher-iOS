//
//  PostPathHistoriesUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/9/25.
//

public protocol PostPathHistoriesUseCase {
    func execute(departureStationId: Int, arrivalStationId: Int) async throws
}

public final class PostPathHistoriesImpl: PostPathHistoriesUseCase {
    public init() {}

    public func execute(departureStationId: Int, arrivalStationId: Int) async throws {
        
    }
}
