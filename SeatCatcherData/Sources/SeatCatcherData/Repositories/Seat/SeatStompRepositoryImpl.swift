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
    private let messageSubject = PassthroughSubject<TrainCar, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    public var isConnectedPublisher: AnyPublisher<Bool, Never> {
        stompClientService.isConnectedPublisher
    }
    
    public init(stompClientService: StompClientService) {
        self.stompClientService = stompClientService
        bindStompMessages()
    }
    
    public func trainCarPublisher(carCode: String) -> AnyPublisher<TrainCar, Error> {
        messageSubject
            .filter { $0.carCode == carCode }
            .eraseToAnyPublisher()
    }
    
    private func bindStompMessages() {
        stompClientService.messagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.messageSubject.send(completion: .failure(error))
                }
            }, receiveValue: { [weak self] stompMessage in
                self?.handleStompMessage(stompMessage)
            })
            .store(in: &cancellables)
    }
    
    private func handleStompMessage(_ message: StompTextMessageDTO) {
        guard let data = message.text.data(using: .utf8) else {
            messageSubject.send(completion: .failure(SeatCatcherDataError.nullValue))
            return
        }
        
        do {
            let responseDTO = try decoder.decode(GetSeatInTrainCarResponseDTO.self, from: data)
            let trainCar = responseDTO.domainModel
            messageSubject.send(trainCar)
        } catch {
            messageSubject.send(completion: .failure(error))
        }
    }
    
    public func subscribeToTrainCarSeats(trainCode: String) {
        let topic = "/train/\(trainCode)"
        stompClientService.subscribe(topic: topic)
    }
    
    public func unsubscribeFromTrainCarSeats(trainCode: String) {
        let topic = "/train/\(trainCode)"
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
