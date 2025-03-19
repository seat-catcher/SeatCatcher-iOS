//
//  AppleLoginRepository.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 3/19/25.
//

import Foundation

public protocol AppleLoginRepository {
    func login(_ token: Data) -> String?
}
