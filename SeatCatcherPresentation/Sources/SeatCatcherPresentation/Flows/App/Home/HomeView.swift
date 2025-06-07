//
//  HomeView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import SwiftUI
import SeatCatcherCore
import SeatCatcherDomain

public struct HomeView: View {
    @State private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 18) {
                UserInfoCardView(viewModel: viewModel)
                PathCardView(viewModel: viewModel)
                ActionPanelView(viewModel: viewModel)
                Spacer()
            }
        }
        .onAppear { viewModel.action(.viewWillAppear) }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 18)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .logoWithNotification(notificationButtonAction: {
                viewModel.action(.notificationButtonTapped)
            })
        )
        .alert(
            viewModel.state.isCreditStoreAlertPresented,
            alert: .init(
                title: "아직 준비 중이에요",
                subtitle: "곧 크레딧스토어가 열려요",
                buttonTitle: "돌아가기",
                buttonAction: { viewModel.action(.alertPrimaryButtonTapped) }
            )
        )
    }
}

private struct UserInfoCardView: View {
    let viewModel: HomeViewModel
    @State private var tagScrollViewWidth: CGFloat = .zero

    var body: some View {
        Button {
            viewModel.action(.userInfoCardTapped)
        } label: {
            HStack(alignment: .center, spacing: 12) {
                Image(viewModel.store.user.profileImage.image)
                    .resizable()
                    .frame(width: 68, height: 68)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(viewModel.store.user.name)")
                        .font(.B01_SB)
                        .foregroundStyle(.white)
                    HStack(spacing: 6) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(viewModel.store.user.tags) {
                                    UserInfoBadge(.tag($0))
                                }
                            }
                            .background(
                                GeometryReader { Color.clear.onChange(of: $0.size) { tagScrollViewWidth = $1.width } }
                            )
                        }
                        .frame(maxWidth: tagScrollViewWidth)
                        UserInfoBadge(.credit(viewModel.store.user.credit))
                        Spacer()
                    }
                }
                VStack {
                    Image(.iconRightArrow)
                    Spacer()
                }
                .frame(height: 68)
            }
            .padding(12)
            .background(.gray850)
            .clipShape(.rect(cornerRadius: 12))
            .padding(.top, 18)
        }
    }
}

private struct PathCardView: View {
    let viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 14) {
            Text(viewModel.state.guidingText)
                .font(.B02_SB)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
            PathCardContentView(viewModel: viewModel)
        }
        .padding(EdgeInsets(top: 14, leading: 14, bottom: 18, trailing: 14))
        .background(.gray850)
        .clipShape(.rect(cornerRadius: 12))
    }
}

private struct ActionPanelView: View {
    let viewModel: HomeViewModel

    var body: some View {
        HStack(spacing: 11) {
            HomeCreditStoreButton(viewModel: viewModel)
            HomeCatchSeatButton(viewModel: viewModel)
        }
    }
}

private struct PathCardContentView: View {
    let viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state.userStatus {
            case .inTransit:
                PathCardInTransit(viewModel: viewModel)
            case .pathExists:
                PathCardPathExists(viewModel: viewModel)
            case .pathNotExists:
                PathCardPathNotExists()
            }

        }
        .padding(EdgeInsets(top: 18, leading: 18, bottom: 0, trailing: 18))
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.gray700, lineWidth: 2)
        )
    }
}

private struct HomeCreditStoreButton: View {
    let viewModel: HomeViewModel

    var body: some View {
        Button {
            viewModel.action(.creditStoreButtonTapped)
        } label: {
            VStack {
                HStack {
                    Text("크레딧스토어")
                        .font(.B01_SB)
                        .foregroundStyle(.white)
                    Spacer()
                    Image(.iconRightArrow)
                        .renderingMode(.template)
                        .foregroundStyle(.gray300)
                }
                .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 6))

                Spacer()

                Image(.iconCoinStore)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 8))
            }
            .frame(height: 137)
            .frame(maxWidth: .infinity)
            .background(.gray850)
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}

private struct HomeCatchSeatButton: View {
    let viewModel: HomeViewModel

    var body: some View {
        Button {
            viewModel.action(.catchSeatButtonTapped)
        } label: {
            VStack {
                HStack {
                    Text("좌석찾기")
                        .font(.B01_SB)
                        .foregroundStyle(.white)
                    Spacer()
                    Image(.iconRightArrow)
                        .renderingMode(.template)
                        .foregroundStyle(.gray100)
                }
                .padding(EdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 6))

                Spacer()

                Image(.iconFindSeat)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 8))
            }
            .frame(height: 137)
            .frame(maxWidth: .infinity)
            .background(.scGreen)
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}

private struct PathCardInTransit: View {
    let viewModel: HomeViewModel

    var body: some View {
        TimelineView(.periodic(from: .now, by: 5)) { timeline in
            let now = timeline.date
            var remainingTimeString: String {
                let remainingTime = Int((viewModel.state.expectedRemainingTime ?? 0) / 60)
                return remainingTime <= 0 ? "곧 도착해요" : "\(remainingTime)분 남았어요"
            }
            var departureTimeString: String { (viewModel.store.departureTime ?? now).amPmTime }
            var arrivalTimeString: String { (viewModel.store.expectedArrivalTime ?? now).hour12Time }
            var elapsedTime: Double? {
                guard let departureTime = viewModel.store.departureTime else { return nil }
                return now.timeIntervalSince(departureTime)
            }
            var progressFraction: CGFloat {
                let totalDuration = Double(viewModel.state.totalTimeInterval ?? 0)
                guard totalDuration > 0, let elapsedTime = elapsedTime else { return 0 }
                let result = CGFloat(min(max(elapsedTime / totalDuration, 0), 1))
                return result
            }

            Text(remainingTimeString)
                .font(.B01_SB)
                .foregroundStyle(.scWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 6)

            HStack(spacing: 6) {
                Text("지금 승차시")
                    .font(.C01_M)
                    .foregroundStyle(.gray200)
                Text("\(departureTimeString)-\(arrivalTimeString)")
                    .font(.C01_R)
                    .foregroundStyle(.gray300)
                Spacer()
            }
            .padding(.bottom, 14)

            GeometryReader { proxy in
                ZStack {
                    Capsule().fill(.gray500).frame(height: 14)
                    HStack {
                        Capsule().fill(.scGreen).frame(width: proxy.size.width * progressFraction, height: 14)
                        Spacer()
                    }
                    Image(.iconProgressIndicator)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: proxy.size.width * progressFraction - 11)
                }
            }
            .padding(.bottom, 14)

            Rectangle()
                .frame(height: 1.5)
                .foregroundStyle(.gray700)
                .padding(.top, 14)
                .padding(.bottom, 18)

            // MARK: - 승/하차역
            HStack(spacing: 0) {
                StationNodeView(.departure)
                    .padding(.trailing, 6)
                Text("승차")
                    .font(.B03_M)
                    .foregroundStyle(.gray400)
                    .padding(.trailing, 10)
                LineNumberCircle(.init(rawValue: viewModel.store.departure?.line ?? 2) ?? .two)
                    .padding(.trailing, 4)
                Text("\(viewModel.store.departure?.name ?? "")역")
                    .font(.B03_M)
                    .foregroundStyle(.scWhite)
                Spacer()
            }

            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .frame(width: 1.4, height: 26)
                    .foregroundStyle(.gray600)
                    .padding(EdgeInsets(top: -10, leading: 5.2, bottom: -5, trailing: 0))
                Spacer()
            }

            HStack(spacing: 0) {
                StationNodeView(.arrival)
                    .padding(.trailing, 6)
                Text("하차")
                    .font(.B03_M)
                    .foregroundStyle(.gray400)
                    .padding(.trailing, 10)
                Text("\(viewModel.state.pathHistory?.arrivalStationName ?? "")역")
                    .font(.B03_M)
                    .foregroundStyle(.scWhite)
                Spacer()
            }
            .padding(.bottom, 18)

            Rectangle()
                .frame(height: 2)
                .padding(.horizontal, -18)
                .foregroundStyle(.gray700)

            // MARK: - 좌석 찾기 버튼
            Button {
                viewModel.action(.quickBoardingButtonTapped)
            } label: {
                Text("바로 좌석 찾기")
                    .font(.B02_B)
                    .foregroundStyle(.scGreen)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// FIXME: - 소요시간
private struct PathCardPathExists: View {
    let viewModel: HomeViewModel
    var departureTimeString: String {
        viewModel.state.incoming?.arrivalTime.amPmTime ?? ""
    }
    var arrivalTimeString: String {
        viewModel.state.incoming?.arrivalTime.addingTimeInterval(60 * 15).hour12Time ?? ""
    }

    var body: some View {
        // MARK: - 소요 시간
        Text("\(15)분")
            .font(.B01_SB)
            .foregroundStyle(.scWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 6)
        HStack(spacing: 6) {
            Text("지금 승차시")
                .font(.C01_M)
                .foregroundStyle(.gray200)
            Text("\(departureTimeString)-\(arrivalTimeString)")
                .font(.C01_R)
                .foregroundStyle(.gray300)
            Spacer()
        }
        Rectangle()
            .frame(height: 1.5)
            .foregroundStyle(.gray700)
            .padding(.top, 10)
            .padding(.bottom, 18)

        // MARK: - 승/하차역
        HStack(spacing: 0) {
            StationNodeView(.departure)
                .padding(.trailing, 6)
            Text("승차")
                .font(.B03_M)
                .foregroundStyle(.gray400)
                .padding(.trailing, 10)
            LineNumberCircle(.init(rawValue: viewModel.state.pathHistory?.line ?? 2) ?? .two)
                .padding(.trailing, 4)
            Text("\(viewModel.state.pathHistory?.departureStationName ?? "")역")
                .font(.B03_M)
                .foregroundStyle(.scWhite)
            Spacer()
        }
        HStack(alignment: .top, spacing: 0) {
            Rectangle()
                .frame(width: 1.4, height: 60)
                .foregroundStyle(.gray600)
                .padding(EdgeInsets(top: -3, leading: 5.2, bottom: -2, trailing: 46))
            if let incoming = viewModel.state.incoming {
                Group {
                    Text("\(viewModel.state.incoming?.arrivalTime.hour24Time ?? "")")
                        .font(.C01_SB)
                        .foregroundStyle(.scGreen)
                        .padding(.trailing, 4)

                    Text("\(viewModel.state.incoming?.destination ?? "")행")
                        .font(.C01_R)
                        .foregroundStyle(.gray300)
                }
                .padding(.top, 6)
            }
            Spacer()
        }
        HStack(spacing: 0) {
            StationNodeView(.arrival)
                .padding(.trailing, 6)
            Text("하차")
                .font(.B03_M)
                .foregroundStyle(.gray400)
                .padding(.trailing, 10)
            Text("\(viewModel.state.pathHistory?.arrivalStationName ?? "")역")
                .font(.B03_M)
                .foregroundStyle(.scWhite)
            Spacer()
        }
        .padding(.bottom, 18)
        Rectangle()
            .frame(height: 2)
            .padding(.horizontal, -18)
            .foregroundStyle(.gray700)

        // MARK: - 좌석 찾기 버튼
        Button {
            viewModel.action(.quickBoardingButtonTapped)
        } label: {
            Text("바로 좌석 찾기")
                .font(.B02_B)
                .foregroundStyle(.scGreen)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
        }
    }
}

private struct PathCardPathNotExists: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(.iconHistoryNotFound)
            Text("아직 자주 이용한 경로가 없어요")
                .font(.B01_SB)
                .foregroundStyle(.scWhite)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 44)
    }
}
