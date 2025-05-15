//
//  UnlockSeatUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/15/25.
//

import Foundation

public protocol UnlockSeatUseCase {
    func execute(_ seat: Seat) -> Seat
}

public final class UnlockSeatUseCaseImpl: UnlockSeatUseCase {
    
    public init() {}
    
    public func execute(_ seat: Seat) -> Seat{
        var newSeat = seat
        newSeat.isBlocked = false
        return newSeat
    }
}
