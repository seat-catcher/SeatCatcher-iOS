//
//  AccessTokenProvider.swift
//  SeatCatcherData
//
//  Created by 박현수 on 6/7/25.
//

import Combine
import Foundation
import SeatCatcherDomain

public final class AccessTokenProvider {
    private let tokenRepository: TokenRepository
    private let stompService: StompClientService
    private var cancellables = Set<AnyCancellable>()

    public init(tokenRepository: TokenRepository, stompService: StompClientService) {
        self.tokenRepository = tokenRepository
        self.stompService = stompService
        bindTokenPublisher()
    }

    private func bindTokenPublisher() {
        tokenRepository.accessTokenPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] accessToken in
                guard let self = self else { return }
                let headers = ["Authorization": "Bearer \(accessToken)"]
                self.stompService.resetHeadersAndReconnect(headers)
            }
            .store(in: &cancellables)
    }
}
