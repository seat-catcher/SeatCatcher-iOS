//
//  SeatRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 5/18/25.
//

import Foundation
import SeatCatcherDomain

public final class SeatRepositoryImpl: SeatRepository, Sendable {
    
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getSeatsInTrainCar(trainCode: String, carCode: String) async throws -> TrainCar {
        return GetSeatInTrainCarResponseDTO.stub.domainModel
        
        let response = try await networkService.getSeatsInTrainCar(trainCode: trainCode, carCode: carCode)
        return response.domainModel
    }

    public func unlockAllSeats() async throws {
        // TODO: 크레딧 차감 API 호출
        return
    }
        
    public func registerSeat(_ seat: Seat) async throws {
        // 새로운 좌석 등록
        try await networkService.registerSeat(seatId: seat.id, creditAmount: 0) // FIXME: 유저 데이터와 연결
    }
    
    public func cancelSeat() async throws {
        // 기존 좌석 취소
        try await networkService.cancelSeat()
    }
}
