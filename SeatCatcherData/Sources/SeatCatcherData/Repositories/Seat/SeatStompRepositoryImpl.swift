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
final class SeatStompRepositoryImpl: SeatStompRepository {
    private let stompClient: StompClientServiceProtocol
    private let decoder = JSONDecoder()
    private let messageSubject = PassthroughSubject<TrainCar, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    /// 유즈케이스에서 구독할 퍼블리셔입니다
    var trainCarPublisher: AnyPublisher<TrainCar, Error> {
        messageSubject.eraseToAnyPublisher()
    }
    
    public init(stompClient: StompClientServiceProtocol) {
        self.stompClient = stompClient
        bindStompMessages()
    }
    
    private func bindStompMessages() {
        stompClient.messagePublisher
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
    
    func subscribeToTrainCarSeats(trainCode: String) {
        let topic = "/train/\(trainCode)"
        stompClient.subscribe(topic: topic)
    }
    
    func unsubscribeFromTrainCarSeats(trainCode: String) {
        let topic = "/train/\(trainCode)"
        stompClient.unsubscribe(topic: topic)
    }
}
