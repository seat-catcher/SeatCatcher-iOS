//
//  SearchStationsView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/8/25.
//

import SwiftUI
import SeatCatcherDomain

public struct SearchStationsView: View {
    let viewModel: SelectPathViewModel

    public init(viewModel: SelectPathViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            GuidingText(viewModel: viewModel)
            SearchResultsList(viewModel: viewModel)
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

private struct GuidingText: View {
    let viewModel: SelectPathViewModel

    var body: some View {
        Text((viewModel.state.searchText.isEmpty) ? "최근 검색" : "")
            .font(.B03_M)
            .foregroundStyle(.gray300)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .padding(.bottom, viewModel.state.searchText.isEmpty ? 0 : -18)
    }
}

private struct SearchResultsList: View {
    let viewModel: SelectPathViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.state.searchResults) {
                    SearchResultCell(viewModel: viewModel, station: $0)
                }
            }
        }
    }
}

private struct SearchResultCell: View {
    let viewModel: SelectPathViewModel
    let station: Station

    var body: some View {
        VStack(spacing: 0) {
            Button {
                viewModel.action(.searchResultTapped(station: station))
            } label: {
                HStack(spacing: 4) {
                    LineNumberCircle(station.line)
                    Text(station.name)
                        .font(.B02_M)
                        .foregroundStyle(.gray100)
                        .lineLimit(1)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(18)
            }
            Rectangle().fill(.gray800).frame(height: 1)
        }
    }
}
