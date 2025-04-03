//
//  DIContainer.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SeatCatcherDomain

public protocol DIContainer {
    func resolveAuthUseCase() -> AuthUseCase
    func resolveUserUseCase() -> UserUseCase
}
