//
//  SeatSectionView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/17/25.
//

import SwiftUI
import SeatCatcherDomain

public struct SeatSectionView: View {
    let selectedSeat: Seat?
    let isBlocked: Bool
    let seats: (topSeats: [Seat], bottomSeats: [Seat])
    let userStatus: MainFeatureViewModel.UserStatus
    let onTap: (Seat) -> Void
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SeatRowView(
                isBlocked: isBlocked,
                seats: seats.topSeats,
                selectedSeat: selectedSeat,
                userStatus: userStatus,
                onTap: onTap
            )
            Spacer()
            SeatRowView(
                isBlocked: isBlocked,
                seats: seats.bottomSeats,
                selectedSeat: selectedSeat,
                userStatus: userStatus,
                onTap: onTap
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray800, lineWidth: 3)
        )
    }
}

private struct SeatRowView: View {
    let isBlocked: Bool
    let seats: [Seat]
    let selectedSeat: Seat?
    let userStatus: MainFeatureViewModel.UserStatus
    let onTap: (Seat) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ForEach(seats) { seat in
                if shouldShowSeat(seat: seat) {
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
    
    private func shouldShowSeat(seat: Seat) -> Bool {
        /// 좌석 이동/등록 시엔 점유된 좌석은 보여주지 않습니다
        return !(userStatus == .selecting && seat.isAvailable)
    }
}
