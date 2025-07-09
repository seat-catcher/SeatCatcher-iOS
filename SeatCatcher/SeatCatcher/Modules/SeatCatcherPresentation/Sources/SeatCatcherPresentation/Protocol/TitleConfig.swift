//
//  TitleConfig.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/8/25.
//

import Foundation

public struct TitleConfig {
    let title: String
    let subtitle: String?
    let isSubtitleUnderlined: Bool
    
    init(title: String = "", subtitle: String? = nil, isSubtitleUnderlined: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.isSubtitleUnderlined = isSubtitleUnderlined
    }
}
