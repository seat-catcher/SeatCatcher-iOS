//
//  TempCommonUI.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import SwiftUI

extension View {
    func withBackground() -> some View {
        ZStack { self }
        .background(.black)
        .background(ignoresSafeAreaEdges: .all)
    }
}
