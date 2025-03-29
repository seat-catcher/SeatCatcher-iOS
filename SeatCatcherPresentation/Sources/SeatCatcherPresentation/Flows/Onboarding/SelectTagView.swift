//
//  SelectTagView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/29/25.
//

import SwiftUI
import SeatCatcherDomain

public struct SelectTagView: View {
    @State private var viewModel: SelectTagViewModel

    public init(viewModel: SelectTagViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            SelectTagGuideTextView()
            SelectTagGridView(viewModel: viewModel)
            Spacer()
            SelectTagNextButton(viewModel: viewModel)
        }
        .padding(.horizontal, 20)
        .applyToolbarVisibility(.hidden, for: .navigationBar)
        .withNavigationBar(viewModel.coordinator)
        .withBackground()
    }
}

private struct SelectTagGuideTextView: View {
    var body: some View {
        Text("지하철 탈 때\n주로 어떤 유형이세요?")
            .font(.system(size: 26, weight: .bold))
            .foregroundStyle(.white)
            .lineSpacing(4)
            .padding(.bottom, 11)
            .frame(maxWidth: .infinity, alignment: .leading)

        HStack(alignment: .center, spacing: 0) {
            Image(.dangerCircle)
            Text("장거리/단거리 이용객 기준")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.gray)
                .lineSpacing(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 25)
    }
}

private struct SelectTagCell: View {
    let viewModel: SelectTagViewModel
    let tag: UserTag

    var body: some View {
        Rectangle()
            .fill(tag == viewModel.state.currentTag ? .green : .gray)
            .clipShape(.rect(cornerRadius: 8))
            .onTapGesture { withAnimation(.easeInOut(duration: 0.1)) { viewModel.action(.tagSelected(tag)) } }
    }
}

private struct SelectTagGridView: View {
    let viewModel: SelectTagViewModel
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
    let viewModel: SelectTagViewModel

    var body: some View {
        Button {
            viewModel.action(.nextButtonTapped)
        } label: {
            Text("다음")
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(viewModel.state.currentTag != nil ? .green : .gray)
                .clipShape(.rect(cornerRadius: 8))
        }
        .disabled(viewModel.state.currentTag == nil)

    }
}
