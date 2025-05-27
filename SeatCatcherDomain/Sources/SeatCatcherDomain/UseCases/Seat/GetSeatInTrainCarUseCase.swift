//
//  GetSeatInTrainCarUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 5/27/25.
//

import Foundation

public protocol GetSeatInTrainCarUseCase: Sendable {
    // 해당 열차 내 모든 구역의 좌석 정보를 가져옵니다
    func execute(trainCode: String, carCode: String) async throws -> TrainCar
}

public final class GetSeatInTrainCarUseCaseImpl: GetSeatInTrainCarUseCase {
    
    private let seatRepository: SeatRepository
    
    public init(seatRepository: SeatRepository) {
        self.seatRepository = seatRepository
    }
    
    public func execute(trainCode: String, carCode: String) async throws -> TrainCar {
        try await seatRepository.getSeatsInTrainCar(trainCode: trainCode, carCode: carCode)
    }
}
