//
//  SeatSectionType.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/20/25.
//

import Foundation

public enum SeatSectionType: String, Sendable, CaseIterable {
    case priority_A = "교통약자구역 A"
    case normal_A = "일반구역 A"
    case normal_B = "일반구역 B"
    case normal_C = "일반구역 C"
    case priority_B = "교통약자구역 B"
}
