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

                OnboardingMessageView(scrollID: scrollID)

                Spacer()

                OnboardingProgressIndicatorView(
                    viewModel: viewModel,
                    scrollID: scrollID
                )

                OnboardingNextButton(viewModel: viewModel, scrollID: $scrollID)
            }
        }
        .withBackground(.gray900)
        .onAppear { scrollID = 0 }
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
                    .font(.C01_R)
                    .lineSpacing(2.5)
                    .baselineOffset(2)
                    .foregroundStyle(.gray200)
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

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<pageCount, id: \.self) { index in
                    OnboardingContentsCell(size: size, index: index)
                }
            }
            .scrollTargetLayout()
        }
        .frame(width: size.width, height: size.width / 375 * 400)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollID)
        .animation(.default, value: scrollID)
    }
}

private struct OnboardingContentsCell: View {
    let size: CGSize
    let index: Int
    let lastIndex = 3

    let contentsRatio: CGFloat = 400 / 375

    var body: some View {
        Group {
            switch index {
            case 0:
                VStack {
                    Spacer()
                    Image(.firstOnboarding)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 43)
                }
            case 1:
                VStack {
                    Spacer()
                    Image(.secondOnboarding)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 43)
                }
            case 2:
                VStack {
                    Spacer()
                    Image(.thirdOnboarding)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 43)
                        .padding(.bottom, 50)
                }
            case 3:
                VStack {
                    Spacer()
                    Image(.fourthOnboarding)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 64)
                        .padding(.bottom, 50)
                }
            default:
                EmptyView()
            }
        }
        .frame(width: size.width, height: size.width * contentsRatio)
        .background(index == lastIndex ? .gray900 : .gray500)
    }
}

private struct OnboardingMessageView: View {
    let scrollID: Int?

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
        .font(.T01_SB)
        .foregroundStyle(.scWhite)
        .multilineTextAlignment(.center)
        .lineSpacing(4)
        .padding(.top, 50)
    }
}

private struct OnboardingProgressIndicatorView: View {
    let viewModel: OnboardingViewModel
    let scrollID: Int?

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<4) {
                Ellipse()
                    .fill( scrollID == $0 ? .scGreen : .gray500)
                    .opacity( scrollID == $0 ? 1 : 0.2 )
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.bottom, 24)
    }
}

private struct OnboardingNextButton: View {
    let viewModel: OnboardingViewModel
    let lastScrollID = 3
    @Binding var scrollID: Int?

    var body: some View {
        Button {
            if (scrollID ?? 0) < lastScrollID {
                scrollID? += 1
            } else {
                viewModel.action(.nextButtonTapped)
            }
        } label: {
            Text(scrollID == lastScrollID ? "시작하기" : "다음")
                .foregroundStyle(.scWhite)
                .font(.B01_SB)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(.green)
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding(.horizontal, 20)
    }
}
