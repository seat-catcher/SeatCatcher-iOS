//
//  UserInfoView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/29/25.
//

import SwiftUI
import SeatCatcherDomain

public struct UserInfoView: View {
    @State private var viewModel: UserInfoViewModel

    public init(viewModel: UserInfoViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            UserInfoNavigationBar(viewModel: viewModel)
            UserInfoTextView(viewModel: viewModel)
            UserInfoGridView(viewModel: viewModel)
            Spacer()
            SelectTagNextButton(viewModel: viewModel)
        }
        .padding(.horizontal, 20)
        .withBackground(.gray900)
        .applyToolbarVisibility(.hidden, for: .navigationBar)
        .alert(
            viewModel.state.isAlertPresented,
            alert: SCAlertView(
                title: "장거리 단거리 이용 기준",
                subtitle: "장거리와 단거리는\n이동시간 1시간을 기준으로 해요!",
                buttonTitle: "확인",
                buttonAction: { viewModel.action(.alertConfirmButtonTapped) }
            )
        )
    }
}

private struct UserInfoNavigationBar: View {
    let viewModel: UserInfoViewModel

    var body: some View {
        HStack {
            Button(action: viewModel.coordinator.pop) {
                Image(.iconLeftArrow)
            }
            .padding(.top, 12)
            .padding(.bottom, 28)

            Spacer()
        }
    }
}

private struct UserInfoTextView: View {
    let viewModel: UserInfoViewModel

    var body: some View {
        Text("지하철 탈 때\n주로 어떤 유형이세요?")
            .font(.T01_SB)
            .foregroundStyle(.scWhite)
            .lineSpacing(4)
            .padding(.bottom, 11)
            .frame(maxWidth: .infinity, alignment: .leading)

        Button {
            withAnimation { viewModel.action(.criterionButtonTapped) }
        } label: {
            HStack(alignment: .center, spacing: 0) {
                Image(.dangerCircle)
                Text("장거리/단거리 이용객 기준")
                    .font(.B03_M)
                    .foregroundStyle(.gray300)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.bottom, 25)
    }
}

private struct SelectTagCell: View {
    let viewModel: UserInfoViewModel
    let tag: Tag

    private var imageForTag: Image {
        switch tag {
        case .longDistance: Image(.tagLongDistance)
        case .tired: Image(.tagTired)
        case .pregnant: Image(.tagPregnant)
        case .disabled: Image(.tagDisabled)
        case .baggage: Image(.tagBaggage)
        case .none: Image(.tagNone)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Group {
                imageForTag
                    .renderingMode(.template)

                Text(tag.stringValue)
                    .font(.B02_M)
            }
            .foregroundStyle(tag == viewModel.state.currentTag ? .scGreen : .gray300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(tag == viewModel.state.currentTag ? .scGreen700 : .gray500)
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture { viewModel.action(.tagSelected(tag)) }
    }
}

private struct UserInfoGridView: View {
    let viewModel: UserInfoViewModel
    let columns: [GridItem] = [
        .init(.flexible(), spacing: 11),
        .init(.flexible(), spacing: 0)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Tag.allCases, id: \.self) {
                SelectTagCell(viewModel: viewModel, tag: $0)
                    .frame(height: 104)
            }
        }
    }
}

private struct SelectTagNextButton: View {
    let viewModel: UserInfoViewModel

    var body: some View {
        Button {
            viewModel.action(.nextButtonTapped)
        } label: {
            Text("다음")
                .foregroundStyle(viewModel.state.currentTag == nil ? .gray300 : .scWhite)
                .font(.B01_SB)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(viewModel.state.currentTag == nil ? .gray500 : .scGreen)
                .clipShape(.rect(cornerRadius: 8))
        }
        .disabled(viewModel.state.currentTag == nil)

    }
}
