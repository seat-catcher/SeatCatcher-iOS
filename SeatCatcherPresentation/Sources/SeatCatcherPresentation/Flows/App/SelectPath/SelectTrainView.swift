//
//  SelectTrainView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/27/25.
//

import SwiftUI

public struct SelectTrainView: View {
    @State private var viewModel: SelectTrainViewModel

    public init(viewModel: SelectTrainViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text("탑승 중인 열차를 선택해 주세요")
                .font(.T02_B)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)
            Spacer()
        }
        .withBackground(.gray900)
    }
}

//#Preview { SelectTrainView(viewModel: .init()).loadCustomFonts() }
