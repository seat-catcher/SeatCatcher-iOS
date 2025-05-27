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
    let seats: SeatSection // 변경: 튜플 대신 SeatSection
    let userStatus: MainFeatureViewModel.UserStatus
    let onTap: (Seat) -> Void
    
    public var body: some View {
        // SeatLocation 대로 정렬
        let topSeats = seats.topSeats.sorted { $0.key < $1.key }.map { $0.value }
        let bottomSeats = seats.bottomSeats.sorted { $0.key < $1.key }.map { $0.value }
        
        VStack(alignment: .center, spacing: 8) {
            SeatRowView(
                isBlocked: isBlocked,
                seats: topSeats,
                selectedSeat: selectedSeat,
                userStatus: userStatus,
                onTap: onTap
            )
            Spacer()
            SeatRowView(
                isBlocked: isBlocked,
                seats: bottomSeats,
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
                    Image(seat.image(
                        isSelected: selectedSeat?.id == seat.id,
                        isBlocked: isBlocked,
                        isSelecting: userStatus == .registering || userStatus == .moving)
                    )
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
        if userStatus == .registering || userStatus == .moving {
            return seat.isEmpty || seat.isMySeat // 빈 좌석과 앉은 자리만 표시
        } else {
            return true  // 다른 상태에서는 모든 좌석 표시
        }
    }
}
