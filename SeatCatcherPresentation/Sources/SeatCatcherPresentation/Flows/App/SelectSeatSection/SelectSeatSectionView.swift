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
                Rectangle()
                    .foregroundStyle(.gray850)
                    .roundedCorner(14, corners: [.bottomLeft, .bottomRight])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 50)
                    .ignoresSafeArea()
                ZStack {
                    VStack(spacing: 10) {
                        ForEach(SeatSectionType.allCases, id: \.self) { section in
                            Button(
                                action: {
                                    viewModel.action(.willSelectOption(section))
                                }, label: {
                                    ZStack {
                                        Text(section.rawValue)
                                            .font(.B01_SB)
                                            .foregroundStyle(viewModel.state.selectedOption == section ? .scGreen : .gray300)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(viewModel.state.selectedOption == section ? .scGreen700 :.gray850)
                                    .clipShape(.rect(cornerRadius: 8))
                                }
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
                }.frame(maxWidth: .infinity)
                Rectangle()
                    .foregroundStyle(.gray850)
                    .roundedCorner(14, corners: [.topLeft, .topRight])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 50)
                    .ignoresSafeArea()
            }
            VStack(spacing: 0) {
                Text(
                    "\(viewModel.state.carCode)칸에서\n탑승한 구역을 선택해주세요",
                    styledSubstring: "\(viewModel.state.carCode)칸",
                    color: .scGreen,
                    font: .T02_B
                )
                .font(.T02_B)
                .foregroundStyle(.gray100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 14)
                Text(
                    "진행방향 \(viewModel.state.carDirection.rawValue)",
                    styledSubstring: viewModel.state.carDirection.rawValue,
                    color: .scGreen,
                    font: .B03_M
                )
                .font(.B03_M)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 18)
            .padding(.leading, 18)
            VStack(spacing: 22) {
                HStack(spacing: 2) {
                    // 토스트 메시지
                    Image(.iconInfo)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text(viewModel.state.availableSections
                        .map { $0.rawValue }
                        .joined(separator: ", ") + "에 좌석정보가 있어요"
                    )
                    .font(.B03_M)
                    .foregroundStyle(.scWhite)
                    .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(.gray500)
                .clipShape(.capsule)
                .padding(.horizontal, 43)
                CTAButton(
                    title: "다음",
                    action: {
                        viewModel.action(.didSelectOption)
                    },
                    style: viewModel.state.selectedOption != nil ? .bottomEnabled : .bottomDisabled
                )
            }
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
