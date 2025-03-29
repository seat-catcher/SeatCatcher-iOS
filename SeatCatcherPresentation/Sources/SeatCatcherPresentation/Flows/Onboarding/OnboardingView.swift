//
//  OnboardingView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import SwiftUI

public struct OnboardingView: View {
    @State private var viewModel: OnboardingViewModel
    @State private var scrollID: Int?

    public init(viewModel: OnboardingViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                OnboardingTopBar(viewModel: viewModel)

                OnboardingContentsView(
                    viewModel: viewModel,
                    scrollID: $scrollID,
                    size: proxy.size
                )

                OnboardingMessageView(scrollID: $scrollID)

                Spacer()

                OnboardingProgressIndicatorView(
                    viewModel: viewModel,
                    scrollID: $scrollID
                )

                OnboardingNextButton(viewModel: viewModel)
            }
        }
        .withBackground()
    }
}

private struct OnboardingTopBar: View {
    let viewModel: OnboardingViewModel

    public var body: some View {
        HStack {
            Spacer()
            Button {
                viewModel.action(.skipButtonTapped)
            } label: {
                Text("건너뛰기")
                    .font(.system(size: 12, weight: .medium))
                    .lineSpacing(2.5)
                    .baselineOffset(2)
                    .foregroundStyle(.gray)
                    .underline(true, color: .gray)
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 22, trailing: 15))
        }
    }
}

private struct OnboardingContentsView: View {
    let viewModel: OnboardingViewModel
    @Binding var scrollID: Int?
    let size: CGSize

    let pageCount = 4
    let contentsRatio: CGFloat = 400 / 375

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<pageCount, id: \.self) { idx in
                    Rectangle()
                        .fill(idx % 2 == 0 ? Color.blue : Color.red)
                        .frame(width: size.width, height: size.width * contentsRatio)
                }
            }
            .scrollTargetLayout()
        }
        .frame(width: size.width, height: size.width / 375 * 400)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollID)
    }
}

private struct OnboardingMessageView: View {
    @Binding var scrollID: Int?

    var body: some View {
        Group {
            switch scrollID {
            case 0:
                Text("자주 이용하는\n경로를 확인해요")
            case 1:
                Text("다른 사람의\n하차역을 알 수 있어요")
            case 2:
                Text("급하게 앉아야 할 때\n간편하게 요청해요")
            case 3:
                Text("편하고 쾌적한 이동\n시트캐쳐와 함께해요")
            default:
                EmptyView()
            }
        }
        .font(.system(size: 26, weight: .semibold))
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .lineSpacing(4)
        .padding(.top, 50)
    }
}

private struct OnboardingProgressIndicatorView: View {
    let viewModel: OnboardingViewModel
    @Binding var scrollID: Int?

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<4) {
                Ellipse()
                    .fill( scrollID == $0 ? .green : .gray )
                    .opacity( scrollID == $0 ? 1 : 0.2 )
                    .frame(width: 8, height: 8)
            }
        }
        .onAppear { scrollID = 0 }
        .padding(.bottom, 24)
    }
}

private struct OnboardingNextButton: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        Button {
            viewModel.action(.nextButtonTapped)
        } label: {
            Text("다음")
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(.green)
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding(.horizontal, 20)
    }
}
