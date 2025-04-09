//
//  Tag.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/5/25.
//

import SwiftUI

public enum Tag: Int, CaseIterable {
    case longDistance = 0
    case tired
    case pregnant
    case disabled
    case baggage
    case none
    
    var icon: ImageResource {
        switch self {
        case .longDistance:
            .tagLongDistance
        case .tired:
            .tagTired
        case .pregnant:
            .tagPregnant
        case .disabled:
            .tagDisabled
        case .baggage:
            .tagBaggage
        case .none:
            .tagNone
        }
    }

    var stringValue: String {
        switch self {
        case .longDistance: "장거리 이용객"
        case .tired: "체력 저하"
        case .pregnant: "임산부"
        case .disabled: "장애인"
        case .baggage: "짐꾼"
        case .none: "해당사항 없음"
        }
    }
}
