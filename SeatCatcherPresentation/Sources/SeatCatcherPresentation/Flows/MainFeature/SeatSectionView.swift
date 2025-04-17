//
//  SeatSectionView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/17/25.
//

import SwiftUI
import SeatCatcherDomain

public struct SeatSectionView: View {
    
    let topSeats: [Seat]
    let bottomSeats: [Seat]
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .top, spacing: 6) {
                ForEach(topSeats, id: \.id) { seat in
                    Image(seat.image)
                        .frame(width: 40, height: 42)
                }
            }
            Spacer()
            HStack(alignment: .bottom, spacing: 6) {
                ForEach(bottomSeats, id: \.id) { seat in
                    Image(seat.image)
                        .frame(width: 40, height: 42)
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
    }
}
