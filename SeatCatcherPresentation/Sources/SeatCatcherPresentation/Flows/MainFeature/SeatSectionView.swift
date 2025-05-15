//
//  SeatSectionView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/17/25.
//

import SwiftUI
import SeatCatcherDomain

public struct SeatSectionView: View {
    
    @State private var viewModel: SeatSectionViewModel
    
    public init(viewModel: SeatSectionViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .top, spacing: 6) {
                ForEach(viewModel.state.topSeats, id: \.id) { seat in
                    if seat.isVisible {
                        Image(seat.image(isSelected: viewModel.state.selectedSeat?.id == seat.id))
                            .frame(width: 40, height: 42)
                            .onTapGesture {
                                viewModel.action(.willSelectSeat(seat))
                            }
                    } else {
                        Spacer()
                            .frame(width: 40, height: 42)
                    }
                }
            }
            Spacer()
            HStack(alignment: .bottom, spacing: 6) {
                ForEach(viewModel.state.bottomSeats, id: \.id) { seat in
                    if seat.isVisible {
                        Image(seat.image(isSelected: viewModel.state.selectedSeat?.id == seat.id))
                            .frame(width: 40, height: 42)
                            .onTapGesture {
                                viewModel.action(.willSelectSeat(seat))
                            }
                    } else {
                        Spacer()
                            .frame(width: 40, height: 42)
                    }
                }
            }
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
