//
//  UserRepositoryImpl.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/29/25.
//

import SeatCatcherDomain

public final class UserRepositoryImpl: UserRepository {

    public init() {}
    
    public func fetchRandomNickname() async throws -> String {
        let dto = NicknameResponseDTO.stub()
        try await Task.sleep(for: .seconds(0.2))
        return dto.toEntity()
    }
}
