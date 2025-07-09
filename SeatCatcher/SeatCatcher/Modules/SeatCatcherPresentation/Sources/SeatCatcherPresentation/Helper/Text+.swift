//
//  Text+.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/19/25.
//

import SwiftUI

extension Text {
    init(
        _ fullText: String,
        styledSubstring: String,
        color: Color? = nil,
        font: Font? = nil
    ) {
        var attributedString = AttributedString(fullText)
        if let range = attributedString.range(of: styledSubstring) {
            if let color = color {
                attributedString[range].foregroundColor = color
            }
            if let font = font {
                attributedString[range].font = font
            }
        }
        self.init(attributedString)
    }
    
}
