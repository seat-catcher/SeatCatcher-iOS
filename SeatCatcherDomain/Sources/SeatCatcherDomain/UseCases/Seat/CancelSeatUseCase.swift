//
//  CancelSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/22/25.
//

import Foundation

public protocol CancelSeatUseCase: Sendable {
    func execute() async throws
}

public final class CancelSeatUseCaseImpl: CancelSeatUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute() async throws {
        //TODO: 구현
    }
}
