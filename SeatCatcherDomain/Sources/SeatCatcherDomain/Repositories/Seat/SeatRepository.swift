//
//  SeatRepository.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/18/25.
//

import Foundation

public protocol SeatRepository: Sendable {
    func getSeatsInTrainCar(trainCode: Int, carCode: Int) async throws -> TrainCar
    func unlockAllSeats() async throws
}
