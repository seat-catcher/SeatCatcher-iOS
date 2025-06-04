//
//  SeatStompRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 황채웅 on 6/3/25.
//

import Foundation
import Combine
import SeatCatcherDomain
import SeatCatcherData

/// STOMP를 통해 좌석 데이터를 처리하는 리포지토리 구현체
public final class SeatStompRepositoryImpl: SeatStompRepository {
    private let stompClientService: StompClientService
    private let decoder = JSONDecoder()
    private var cancellables = Set<AnyCancellable>()
    
    public var isConnectedPublisher: AnyPublisher<Bool, Never> {
        stompClientService.isConnectedPublisher
    }
    
    public init(stompClientService: StompClientService) {
        self.stompClientService = stompClientService
    }
    
    public func trainCarPublisher(trainCode: String, carCode: String) -> AnyPublisher<TrainCar, Error> {
        stompClientService.messagePublisher
            .receive(on: DispatchQueue.main)
            .filter { $0.destination.hasPrefix("/topic/seat/") && $0.destination.contains(trainCode) }
            .tryMap { message in
                guard let data = message.text.data(using: .utf8) else {
                    throw SeatCatcherDataError.nullValue
                }
                let dto = try self.decoder.decode(GetSeatInTrainCarResponseDTO.self, from: data)
                return dto.domainModel
            }
            .eraseToAnyPublisher()
    }
    
    /// 좌석 점유자 - 좌석 요청 수신
    public func getSeatRequesterPublisher() -> AnyPublisher<SeatRequester, Error> {
        stompClientService.messagePublisher
            .receive(on: DispatchQueue.main)
            .filter { $0.destination.contains("/topic/seat.") && $0.destination.contains(".owner") }
            .tryMap { message in
                guard let data = message.text.data(using: .utf8) else {
                    throw SeatCatcherDataError.nullValue
                }
                // JSON을 임시로 파싱하여 creditAmount 필드 확인
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if jsonObject?["creditAmount"] != nil {
                    // creditAmount가 있으면 SeatRequestResponseDTO로 디코딩
                    let dto = try self.decoder.decode(SeatRequestResponseDTO.self, from: data)
                    return dto.domainModel
                } else {
                    // creditAmount가 없으면 CancelSeatRequestResponseDTO로 디코딩
                    let dto = try self.decoder.decode(CancelSeatRequestResponseDTO.self, from: data)
                    return dto.domainModel
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 좌석 요청자 - 점유자의 응답 수신
    public func getSeatRequesteePublisher() -> AnyPublisher<SeatRequestee, Error> {
        stompClientService.messagePublisher
            .receive(on: DispatchQueue.main)
            .filter { $0.destination.contains("/topic/seat.") && $0.destination.contains(".requester") }
            .tryMap { message in
                guard let data = message.text.data(using: .utf8) else {
                    throw SeatCatcherDataError.nullValue
                }
                let dto = try self.decoder.decode(SeatRequestReplyResponseDTO.self, from: data)
                return dto.domainModel
            }
            .eraseToAnyPublisher()
    }
    
    public func subscribeToTrainCarSeats(trainCode: String) {
        let topic = "/topic/seat/\(trainCode)"
        stompClientService.subscribe(topic: topic)
    }
    
    public func unsubscribeFromTrainCarSeats(trainCode: String) {
        let topic = "/topic/seat/\(trainCode)"
        stompClientService.unsubscribe(topic: topic)
    }
    
    public func subscribeToSeatRequest(_ seat: Seat, requesterId: Int) {
        let topic = "/topic/seat.\(seat.id).requester.\(requesterId)"
        stompClientService.subscribe(topic: topic)
    }
    
    public func unsubscribeFromSeatRequest(_ seat: Seat, requesterId: Int) {
        let topic = "/topic/seat.\(seat.id).requester.\(requesterId)"
        stompClientService.unsubscribe(topic: topic)
    }
    
    public func subscribeToSeatOccupied(_ seat: Seat) {
        let topic = "/topic/seat.\(seat.id).owner"
        stompClientService.subscribe(topic: topic)
    }
    
    public func unsubscribeFromSeatOccupied(_ seat: Seat) {
        let topic = "/topic/seat.\(seat.id).owner"
        stompClientService.unsubscribe(topic: topic)
    }
}
