//
//  InputCarCodeView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/31/25.
//

import SwiftUI

public struct InputCarCodeView: View {
    @State private var viewModel: InputCarCodeViewModel

    public init(viewModel: InputCarCodeViewModel) {
        self._viewModel = @State(initialValue: viewModel)
    }
    
    public var body: some View {
        Text("Input Car Code")
    }
}
