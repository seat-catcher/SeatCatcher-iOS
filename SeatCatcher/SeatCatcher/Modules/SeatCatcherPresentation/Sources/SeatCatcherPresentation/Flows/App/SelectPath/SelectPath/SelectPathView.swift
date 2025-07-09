//
//  SelectPathView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/8/25.
//

import SwiftUI
import SeatCatcherDomain

public struct SelectPathView: View {
    @State private var viewModel: SelectPathViewModel

    public init(viewModel: SelectPathViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.state.histories) {
                        PathHistoryCell(viewModel: viewModel, history: $0)
                    }
                }
            }
            CTAButton(
                title: "열차 선택하기",
                action: { viewModel.action(.nextButtonTapped) },
                style: viewModel.state.isPathSelected ? .bottomEnabled : .bottomDisabled
            )
            .disabled(!viewModel.state.isPathSelected)
            .padding(.top, 18)
            .padding(.horizontal, 18)
        }
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .stationSelection(
                boardingState: viewModel.boardingState,
                departureName: viewModel.state.departure?.name,
                arrivalName: viewModel.state.arrival?.name,
                swapStationsButtonAction: { viewModel.action(.swapButtonTapped) },
                selectDepartureButtonAction: { viewModel.action(.departureButtonTapped) },
                selectArrivalButtonAction: { viewModel.action(.arrivalButtonTapped) }
            )
        )
        .onAppear { viewModel.action(.viewAppeared) }
    }
}

private struct PathHistoryCell: View {
    let viewModel: SelectPathViewModel
    let history: PathHistory

    var body: some View {
        Button {
            viewModel.action(.historyTapped(history: history))
        } label: {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack(spacing: 0) {
                        StationNodeView(.departure)
                            .padding(.trailing, 10)
                        LineNumberCircle(history.line)
                            .padding(.trailing, 4)
                        Text("\(history.departureStationName)역")
                            .font(.B02_M)
                            .foregroundStyle(.gray300)
                        Spacer()
                        Text(history.createdDate)
                            .font(.B03_M)
                            .foregroundStyle(.gray400)
                    }
                    HStack(spacing: 0) {
                        StationNodeView(.arrival)
                            .padding(.trailing, 10)
                        Text("\(history.arrivalStationName)역")
                            .font(.B02_M)
                            .foregroundStyle(.gray100)
                        Spacer()
                    }
                }
                .padding(18)

                Rectangle().fill(.gray800).frame(height: 1)
            }
        }
    }
}


