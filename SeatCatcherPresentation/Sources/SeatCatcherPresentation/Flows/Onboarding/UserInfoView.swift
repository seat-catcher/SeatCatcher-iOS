//
//  UserInfoView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/29/25.
//

import SwiftUI
import SeatCatcherDomain
import SeatCatcherCore

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
        .onAppear { viewModel.action(.viewAppeared) }
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
            viewModel.action(.criterionButtonTapped)
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
    @Environment(AppStore.self) private var appStore
    let viewModel: UserInfoViewModel
    let tag: UserTag

    var body: some View {
        VStack(spacing: 10) {
            Group {
                Image(tag.icon)
                    .renderingMode(.template)

                Text(tag.displayValue)
                    .font(.B02_M)
            }
            .foregroundStyle(appStore.user.tags.contains(tag) ? .scGreen : .gray300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appStore.user.tags.contains(tag) ? .scGreen700 : .gray500)
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
            ForEach(UserTag.allCases, id: \.self) {
                SelectTagCell(viewModel: viewModel, tag: $0)
                    .frame(height: 104)
            }
        }
    }
}

private struct SelectTagNextButton: View {
    @Environment(AppStore.self) private var appStore
    let viewModel: UserInfoViewModel

    var body: some View {
        Button {
            viewModel.action(.nextButtonTapped)
        } label: {
            Text("다음")
                .foregroundStyle(appStore.user.tags.isEmpty ? .gray300 : .scWhite)
                .font(.B01_SB)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(appStore.user.tags.isEmpty ? .gray500 : .scGreen)
                .clipShape(.rect(cornerRadius: 8))
        }
        .disabled(appStore.user.tags.isEmpty)

    }
}
