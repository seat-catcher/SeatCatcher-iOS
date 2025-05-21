//
//  LineNumberCircle.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/22/25.
//

import SwiftUI

struct LineNumberCircle: View {
    enum LineNumber: Int {
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine

        var color: Color {
            switch self {
            case .one: .line1
            case .two: .line2
            case .three: .line3
            case .four: .line4
            case .five: .line5
            case .six: .line6
            case .seven: .line7
            case .eight: .line8
            case .nine: .line9
            }
        }
    }

    let lineNumber: LineNumber

    init(_ lineNumber: LineNumber) { self.lineNumber = lineNumber }
    init(_ lineNumber: Int) { self.lineNumber = .init(rawValue: lineNumber) ?? .two }

    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(lineNumber.color)
            Text("\(lineNumber.rawValue)")
                .font(.LINE)
                .foregroundStyle(.scWhite)
        }
        .frame(width: 16, height: 16)
    }
}

