//
//  SearchStationsView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/8/25.
//

import SwiftUI

public struct SearchStationsView: View {
    let viewModel: SelectPathViewModel

    public init(viewModel: SelectPathViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) {
                Text("\($0)")
            }
        }
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .search(
                placeholder: "여기서 \(viewModel.state.searchMode == .departure ? "승차역" : "하차역") 검색하기",
                text: Binding<String>(
                    get: { viewModel.state.searchText },
                    set: { viewModel.action(.searchTextChanged(text: $0)) }
                )
            )
        )
    }
}
