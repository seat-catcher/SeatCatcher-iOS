//
//  SaveFCMTokenUseCase.swift
//  SeatCatcherDomain
//
//  Created by 황채웅 on 7/17/25.
//

import Foundation

public protocol SaveFCMTokenUseCase {
    func execute(fcmToken: String) throws
}

public final class SaveFCMTokenUseCaseImpl: SaveFCMTokenUseCase {
    private let tokenRepository: TokenRepository
    
    public init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    public func execute(fcmToken: String) throws {
        try self.tokenRepository.saveFCMToken(fcmToken)
    }
}
