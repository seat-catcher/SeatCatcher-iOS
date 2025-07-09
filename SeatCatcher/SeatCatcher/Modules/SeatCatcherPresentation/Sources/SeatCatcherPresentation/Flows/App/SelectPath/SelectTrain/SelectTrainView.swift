//
//  SelectTrainView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/27/25.
//

import SeatCatcherDomain
import SwiftUI

public struct SelectTrainView: View {
    @State private var viewModel: SelectTrainViewModel

    public init(viewModel: SelectTrainViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            TopGuidingText(viewModel: viewModel)
            PathIndicator(viewModel: viewModel)
            IncomingsList(viewModel: viewModel)
            RefreshButton(viewModel: viewModel)
            CTAButton(
                title: "다음",
                action: { viewModel.action(.nextButtonTapped) },
                style: viewModel.state.selectedIncoming == nil ? .bottomDisabled : .bottomEnabled
            )
            .disabled(viewModel.state.selectedIncoming == nil)
            .padding(.horizontal, 18)
        }
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .titleWithHomeButton(title: "좌석 찾기")
        )
        .onAppear { viewModel.action(.viewWillAppear) }
    }
}

private struct TopGuidingText: View {
    let viewModel: SelectTrainViewModel

    var guidingText: String {
        if viewModel.boardingState == .notBoarded { "탑승할 열차를 선택해주세요" }
        else { "탑승 중인 열차를 선택해주세요" }
    }

    var directionText: String {
        if let first = viewModel.state.incomings.first { "\(first.destination)역 방면" }
        else { "" }
    }

    var body: some View {
        Group {
            Text(guidingText)
                .font(.T02_B)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 22)

            Text(directionText)
                .font(.B03_SB)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
                .padding(.bottom, 19)
        }
        .padding(.horizontal, 18)
    }
}

private struct PathIndicator: View {
    let viewModel: SelectTrainViewModel

    var body: some View {
        VStack(spacing: 0) {
            Group {
                HStack(spacing: 10) {
                    StationNodeView(.departure)
                    Text("\(viewModel.departure.name)역")
                        .font(.B02_M)
                        .foregroundStyle(.gray300)
                    Spacer()
                }
                .padding(.vertical, 13)

                Rectangle().fill(.gray700).frame(height: 1.4)

                HStack(spacing: 10) {
                    StationNodeView(.arrival)
                    Text("\(viewModel.arrival.name)역")
                        .font(.B02_M)
                        .foregroundStyle(.gray300)
                    Spacer()
                }
                .padding(.vertical, 13)
            }
            .padding(.horizontal, 18)
        }
        .background(.gray850)
    }
}

private struct IncomingsList: View {
    let viewModel: SelectTrainViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.state.incomings) {
                    IncomingsCell(viewModel: viewModel, incoming: $0)
                }
            }
        }
        .refreshable(action: { viewModel.action(.pulledToRefresh) })
        .padding(.top, 20)
    }
}

private struct RefreshButton: View {
    let viewModel: SelectTrainViewModel
    var body: some View {
        Button {
            viewModel.action(.refreshButtonTapped)
        } label: {
            Text("열차 정보 새로고침")
                .font(.REFRESH)
                .foregroundStyle(.gray300)
                .underline(true)
                .padding(.top, 10)
                .padding(.bottom, 20)
        }
    }
}

private struct IncomingsCell: View {
    let viewModel: SelectTrainViewModel
    let incoming: Incoming

    var body: some View {
        HStack(spacing: 10) {
            Text(incoming.arrivalTime.hour24Time)
                .font(.B02_SB)
                .foregroundStyle(.scGreen)
                .monospacedDigit()
            Text("\(incoming.destination)행")
                .font(.B02_M)
                .foregroundStyle(.gray100)
            Spacer()
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 18)
        .background(viewModel.state.selectedIncoming == incoming ? .gray700 : .clear)
        .onTapGesture { viewModel.action(.incomingSelected(incoming)) }

        Rectangle().fill(.gray700).frame(height: 1)
    }
}
