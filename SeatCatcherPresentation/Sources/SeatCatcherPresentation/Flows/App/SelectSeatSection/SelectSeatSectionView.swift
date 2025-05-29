//
//  SelectSeatSectionView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/28/25.
//

import SwiftUI
import SeatCatcherDomain

public struct SelectSeatSectionView: View {
    
    @State private var viewModel: SelectSeatSectionViewModel
    
    public init(viewModel: SelectSeatSectionViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                BackgroundCarView(isBottom: false)
                TrainCarView(
                    hasSeatInfoOptions: viewModel.state.availableSections,
                    selectedOption: viewModel.state.selectedOption,
                    onSelect: { section in
                        viewModel.action(.willSelectOption(section))
                    }
                )
                BackgroundCarView(isBottom: true)
            }
            TitleView(
                carCode: viewModel.state.carCode,
                direction: viewModel.state.carDirection
            )
            .padding(.top, 18)
            .padding(.leading, 18)
            CTAButton(
                title: "다음",
                action: { viewModel.action(.didSelectOption) },
                style: viewModel.state.selectedOption != nil ? .bottomEnabled : .bottomDisabled
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal, 18)
        }
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .titleWithHomeButton(
                title: "좌석 찾기",
                backButtonAction: nil,
                homeButtonAction: nil,
                applyDefaultPopAction: true
            )
        )
    }
}

private struct BackgroundCarView: View {
    let isBottom: Bool
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.gray850)
            .roundedCorner(14, corners: isBottom ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 50)
            .ignoresSafeArea()
    }
}

private struct TrainCarView: View {
    let hasSeatInfoOptions: [SeatSectionType]
    let selectedOption: SeatSectionType?
    let onSelect: (SeatSectionType) -> Void
    
    var body: some View {
        ZStack {
            SeatSectionOptionView(
                hasSeatInfoOptions: hasSeatInfoOptions,
                selectedOption: selectedOption,
                onSelect: onSelect
            )
            HStack {
                SideWheelView()
                    .frame(alignment: .leading)
                    .padding(.leading, 43)
                    .padding(.vertical, 44)
                Spacer()
                SideWheelView()
                    .frame(alignment: .trailing)
                    .padding(.vertical, 44)
                    .padding(.trailing, 43)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SeatSectionOptionView: View {
    let hasSeatInfoOptions: [SeatSectionType]
    let selectedOption: SeatSectionType?
    let onSelect: (SeatSectionType) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(SeatSectionType.allCases, id: \.self) { section in
                SeatSectionButton(
                    section: section,
                    isSelected: selectedOption == section,
                    action: { onSelect(section) },
                    hasSeatInfo: hasSeatInfoOptions.contains(section)
                )
            }
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 30)
        .background(.gray700)
        .padding(.horizontal, -3)
        .frame(maxWidth: .infinity)
        .frame(height: 475)
        .clipShape(.rect(cornerRadius: 14))
        .padding(.horizontal, 46)
    }
}

private struct SeatSectionButton: View {
    let section: SeatSectionType
    let isSelected: Bool
    let action: () -> Void
    let hasSeatInfo: Bool
    
    var body: some View {
        Button(action: action) {
            ZStack {
                VStack(alignment: .center, spacing: 4) {
                    Text(section.rawValue)
                        .font(.B01_SB)
                        .foregroundStyle(isSelected ? .scGreen : .gray300)
                    if hasSeatInfo {
                        HStack(spacing: 4) {
                            Text("좌석 정보 있음")
                                .font(.C01_M)
                                .foregroundStyle(.scGreen)
                            Image(.iconCheck)
                                .resizable()
                                .frame(width: 14, height: 14)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isSelected ? .scGreen700 : .gray850)
            .clipShape(.rect(cornerRadius: 8))
        }
    }
}

private struct SideWheelView: View {
    var body: some View {
        VStack(spacing: 41) {
            ForEach(0..<4) { _ in
                Rectangle()
                    .foregroundStyle(.gray600)
                    .frame(width: 6, height: 66)
                    .clipShape(.rect(cornerRadius: 6))
            }
        }
    }
}

private struct TitleView: View {
    let carCode: String
    let direction: SelectSeatSectionViewModel.CarDirection
    
    var body: some View {
        VStack(spacing: 0) {
            CarCodeText(carCode: carCode)
            DirectionIndicator(direction: direction)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct CarCodeText: View {
    let carCode: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(
                "\(carCode)칸에서\n탑승한 구역을 선택해주세요",
                styledSubstring: "\(carCode)칸",
                color: .scGreen,
                font: .T02_B
            )
            .font(.T02_B)
            .foregroundStyle(.gray100)
            .padding(.bottom, 8)
            Spacer(minLength: 0)
        }
    }
}

private struct DirectionIndicator: View {
    let direction: SelectSeatSectionViewModel.CarDirection
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("진행방향")
                    .font(.B03_M)
                    .foregroundStyle(.gray300)
                    .padding(.trailing, 6)
                Text(direction.rawValue)
                    .font(.B03_M)
                    .foregroundStyle(.scGreen)
                    .padding(.trailing, 2)
                Image(direction == .up ? .iconArrowUp : .iconArrowDown)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.gray900)
            .frame(height: 36)
            .clipShape(.rect(cornerRadius: 10))
            Spacer(minLength: 0)
        }
    }
}
