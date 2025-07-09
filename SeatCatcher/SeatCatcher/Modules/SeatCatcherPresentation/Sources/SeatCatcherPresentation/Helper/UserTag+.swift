//
//  UserTag+.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 4/10/25.
//

import SwiftUI
import SeatCatcherDomain

extension UserTag {
    var displayValue: String {
        switch self {
        case .longDistance: "장거리 이용객"
        case .tired: "체력 저하"
        case .pregnant: "임산부"
        case .disabled: "장애인"
        case .baggage: "짐꾼"
        case .none: "해당사항 없음"
        }
    }

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
}
