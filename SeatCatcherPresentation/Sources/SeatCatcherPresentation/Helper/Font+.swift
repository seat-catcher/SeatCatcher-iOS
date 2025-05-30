//
//  Font+.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/2/25.
//

import SwiftUICore

enum SCFontName: String, CaseIterable {
    case bold = "Pretendard-Bold"
    case semibold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
}

public enum SCFontStyle {
    case T01_B
    case T01_SB
    case T02_B
    case T02_SB
    case T03_B
    case T03_SB
    
    case B01_B
    case B01_SB
    case B01_M
    case B02_B
    case B02_SB
    case B02_M
    case B03_B
    case B03_SB
    case B03_M
    
    case C01_M
    case C01_R
    case C01_SB

    case LINE
    case REFRESH

    var weight: String {
        switch self {
        case .T01_B, .T02_B, .T03_B, .B01_B, .B02_B, .B03_B, .LINE:
            return SCFontName.bold.rawValue
        case .T01_SB, .T02_SB, .T03_SB, .B01_SB, .B02_SB, .B03_SB, .C01_SB:
            return SCFontName.semibold.rawValue
        case .B01_M, .B02_M, .B03_M, .C01_M:
            return SCFontName.medium.rawValue
        case .C01_R, .REFRESH:
            return SCFontName.regular.rawValue
        }
    }
    
    var size: Int {
        switch self {
        case .T01_B, .T01_SB:
            return 26
        case .T02_B, .T02_SB:
            return 24
        case .T03_B, .T03_SB:
            return 20
        case .B01_B, .B01_SB, .B01_M:
            return 18
        case .B02_B, .B02_SB, .B02_M, .REFRESH:
            return 16
        case .B03_B, .B03_SB, .B03_M:
            return 14
        case .C01_M, .C01_R, .C01_SB:
            return 12
        case .LINE:
            return 10
        }
    }
    
    var lineSpacing: CGFloat {
        let fontSize = CGFloat(size)
        let lineHeight = fontSize * 1.3
        return lineHeight - fontSize
    }
    
    var font: Font {
        .custom(weight, size: CGFloat(size))
    }
}

extension Font {
    static let T01_B = SCFontStyle.T01_B.font
    static let T01_SB = SCFontStyle.T01_SB.font
    static let T02_B = SCFontStyle.T02_B.font
    static let T02_SB = SCFontStyle.T02_SB.font
    static let T03_B = SCFontStyle.T03_B.font
    static let T03_SB = SCFontStyle.T03_SB.font
    static let B01_B = SCFontStyle.B01_B.font
    static let B01_SB = SCFontStyle.B01_SB.font
    static let B01_M = SCFontStyle.B01_M.font
    static let B02_B = SCFontStyle.B02_B.font
    static let B02_SB = SCFontStyle.B02_SB.font
    static let B02_M = SCFontStyle.B02_M.font
    static let B03_B = SCFontStyle.B03_B.font
    static let B03_SB = SCFontStyle.B03_SB.font
    static let B03_M = SCFontStyle.B03_M.font
    static let C01_M = SCFontStyle.C01_M.font
    static let C01_R = SCFontStyle.C01_R.font
    static let C01_SB = SCFontStyle.C01_SB.font
    static let LINE = SCFontStyle.LINE.font
    static let REFRESH = SCFontStyle.REFRESH.font
}

extension View {
    func font(_ style: SCFontStyle) -> some View {
        self
            .font(style.font)
            .lineSpacing(style.lineSpacing)
    }
}

public struct Fonts {
    public static func registerCustomFonts() {
        SCFontName.allCases.forEach { font in
            guard let url = Bundle.module.url(forResource: font.rawValue, withExtension: "ttf") else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
