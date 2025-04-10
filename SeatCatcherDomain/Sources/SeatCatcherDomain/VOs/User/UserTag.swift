//
//  UserTag.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/10/25.
//

import Foundation

public enum UserTag: String, CaseIterable, Sendable {
    case longDistance = "USERTAG_LONGDISTANCE"
    case tired = "USERTAG_LOWHEALTH"
    case pregnant = "USERTAG_PREGNANT"
    case disabled = "USERTAG_DISABLED"
    case baggage = "USERTAG_CARRIER"
    case none = "USERTAG_NULL"
}
