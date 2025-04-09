//
//  ButtonConfig.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/8/25.
//

import Foundation

public struct ButtonConfig {
    let title: String
    let action: () -> Void
    let heartFilled: Bool?
    let heartCount: Int?
    let coinCount: Int?
    
    init(title: String = "", action: @escaping () -> Void = {}, heartFilled: Bool? = nil, heartCount: Int? = nil, coinCount: Int? = nil) {
        self.title = title
        self.action = action
        self.heartFilled = heartFilled
        self.heartCount = heartCount
        self.coinCount = coinCount
    }
}
