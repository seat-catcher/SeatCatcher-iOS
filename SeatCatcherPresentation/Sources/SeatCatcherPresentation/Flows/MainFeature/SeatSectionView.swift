//
//  SeatSectionView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/17/25.
//

import SwiftUI
import SeatCatcherDomain
import SeatCatcherCore

public struct SeatSectionView: View {
    
    let viewModel: SeatSectionViewModel
    
    public init(viewModel: SeatSectionViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SeatRowView(
                isBlocked: viewModel.state.isBlocked,
                seats: viewModel.state.topSeats,
                selectedSeat: viewModel.state.selectedSeat,
                onTap: { viewModel.action(.willSelectSeat($0)) }
            )
            Spacer()
            SeatRowView(
                isBlocked: viewModel.state.isBlocked,
                seats: viewModel.state.bottomSeats,
                selectedSeat: viewModel.state.selectedSeat,
                onTap: { viewModel.action(.willSelectSeat($0)) }
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray800, lineWidth: 3)
        )
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.action(.willAppear)
        }
    }
}

private struct SeatRowView: View {
    let isBlocked: Bool
    let seats: [Seat]
    let selectedSeat: Seat?
    let onTap: (Seat) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ForEach(seats) { seat in
                if seat.isVisible {
                    Image(seat.image(isSelected: selectedSeat?.id == seat.id, isBlocked: isBlocked))
                        .frame(width: 40, height: 42)
                        .onTapGesture {
                            onTap(seat)
                        }
                } else {
                    Spacer()
                        .frame(width: 40, height: 42)
                }
            }
        }
    }
}
