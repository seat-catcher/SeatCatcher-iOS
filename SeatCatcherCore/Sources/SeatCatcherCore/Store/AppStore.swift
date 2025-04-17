//
//  AppStore.swift
//  SeatCatcherCore
//
//  Created by 박현수 on 4/14/25.
//

import Foundation
import SeatCatcherDomain

@Observable
public final class AppStore {
    public var user: User

    public init(user: User) { self.user = user }

    public func setUser(_ user: User) {
        self.user = user
    }
}
