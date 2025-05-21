//
//  StationNodeView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/22/25.
//

import SwiftUI

struct StationNodeView: View {
    enum NodeType {
        case departure
        case arrival

        var color: Color {
            switch self {
            case .departure: .gray300
            case .arrival: .scGreen
            }
        }
    }

    let nodeType: NodeType

    init(_ nodeType: NodeType) { self.nodeType = nodeType }

    var body: some View {
        Circle()
            .strokeBorder(nodeType.color, lineWidth: 2)
            .frame(width: 12, height: 12)
    }
}
