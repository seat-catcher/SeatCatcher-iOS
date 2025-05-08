//
//  SelectPathView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/8/25.
//

import SwiftUI

public struct SelectPathView: View {
    @State private var viewModel: SelectPathViewModel

    public init(viewModel: SelectPathViewModel) {
        self._viewModel = State(initialValue: viewModel)
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
            config: .stationSelection(
                departureName: viewModel.state.departure?.name,
                arrivalName: viewModel.state.arrival?.name,
                backButtonAction: { viewModel.action(.backButtonTapped) },
                swapStationsButtonAction: { viewModel.action(.swapButtonTapped) },
                selectDepartureButtonAction: { viewModel.action(.departureButtonTapped) },
                selectArrivalButtonAction: { viewModel.action(.arrivalButtonTapped) }
            )
        )
    }
}


