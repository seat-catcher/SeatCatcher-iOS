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
//        return GetSeatInTrainCarResponseDTO.stub.domainModel
        
        let response = try await networkService.getSeatsInTrainCar(trainCode: trainCode, carCode: carCode)
        return response.domainModel
    }

    public func unlockAllSeats(creditAmount: Int, targetUserId: Int) async throws {
        try await networkService.patchCredit(creditAmount: 300, targetUserId: targetUserId)
        return
    }
        
    public func registerSeat(_ seat: Seat) async throws {
        /// 새로운 좌석 등록
        try await networkService.registerSeat(seatId: seat.id, creditAmount: 0) // FIXME: 유저 데이터와 연결
    }
    
    public func cancelSeat() async throws {
        /// 기존 좌석 취소
        try await networkService.cancelSeat()
    }
    
    public func postRequestSeat(_ seat: Seat, creditAmount: Int) async throws {
        try await networkService.postSeatRequest(seatId: seat.id, creditAmount: creditAmount)
    }
    
    public func cancelRequestSeat(_ seat: Seat, creditAmount: Int) async throws {
        try await networkService.cancelSeatRequest(seatId: seat.id, creditAmount: creditAmount)
    }
    
    public func acceptRequestSeat(_ seat: Seat, requesterId: Int) async throws {
        try await networkService.acceptSeatRequest(seatId: seat.id, requesterId: requesterId)
    }
    
    public func changeSeatOccupant(_ seat: Seat, creditAmount: Int) async throws {
        try await networkService.patchSeatOccupant(seatId: seat.id, creditAmount: creditAmount)
    }
    
    public func rejectRequestSeat(_ seat: Seat, requesterId: Int, creditAmount: Int) async throws {
        try await networkService.rejectSeatRequest(seatId: seat.id, requesterId: requesterId, creditAmount: creditAmount)
    }
    
}
