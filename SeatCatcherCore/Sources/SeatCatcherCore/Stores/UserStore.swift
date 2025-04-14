//
//  UserStore.swift
//  SeatCatcherCore
//
//  Created by 박현수 on 4/14/25.
//

import Foundation
import SeatCatcherDomain

@Observable
public final class UserStore {
    public var user: User

    public init(user: User) { self.user = user }
}
