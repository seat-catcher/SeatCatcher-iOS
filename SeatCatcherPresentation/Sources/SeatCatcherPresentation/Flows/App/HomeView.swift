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
                UserInfoCardView()
                PathCardView(.pathExists(
                    travelTime: 31,
                    departureTime: "09:59",
                    arrivalTime: "10:30",
                    incomingTime: "13:15",
                    departureStation: "보라매",
                    departureStationLine: 7,
                    arrivalStation: "숭실대입구",
                    direction: "어린이대공원",
                    finalDestination: "건대입구"
                ))
                ActionPanelView()
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 18)
        .withBackground(.gray900)
        .withNavigationBar(
            viewModel.coordinator,
            config: .logoWithNotification(notificationButtonAction: {})
        )
    }
}

private struct UserInfoCardView: View {
    @Environment(AppStore.self) private var appStore
    var body: some View {
        Button {

        } label: {
            HStack(alignment: .center, spacing: 12) {
                Image(appStore.user.profileImage.image)
                    .resizable()
                    .frame(width: 68, height: 68)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(appStore.user.name)")
                        .font(.B01_SB)
                        .foregroundStyle(.white)
                    HStack(spacing: 6) {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 6) {
                                ForEach(appStore.user.tags) {
                                    UserInfoBadge(.tag($0))
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        UserInfoBadge(.credit(appStore.user.credit))
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
    let userStatus: UserStatus

    init(_ userStatus: UserStatus) { self.userStatus = userStatus }

    var body: some View {
        VStack(spacing: 14) {
            Text(userStatus.guidingText)
                .font(.B02_SB)
                .foregroundStyle(.gray300)
                .frame(maxWidth: .infinity, alignment: .leading)
            PathCardContentView(userStatus)
        }
        .padding(EdgeInsets(top: 14, leading: 14, bottom: 18, trailing: 14))
        .background(.gray850)
        .clipShape(.rect(cornerRadius: 12))
    }
}

private struct ActionPanelView: View {
    var body: some View {
        HStack(spacing: 11) {
            HomeCreditStoreButton()
            HomeCatchSeatButton()
        }
    }
}

private struct PathCardContentView: View {
    let userStatus: UserStatus
    init(_ userStatus: UserStatus) { self.userStatus = userStatus }
    var body: some View {
        VStack(spacing: 0) {
            switch userStatus {
            case .inTransit:
                Text("")
            case let .pathExists(travelTime, departureTime, arrivalTime, incomingTime,
                                 departureStation, departureStationLine, arrivalStation, direction, finalDestination):
                PathCardPathExistsView(travelTime, departureTime, arrivalTime, incomingTime,
                                       departureStation, departureStationLine, arrivalStation, direction, finalDestination)
            case .pathNotExists:
                PathCardPathNotExistsView()
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
    var body: some View {
        Button {} label: {
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
    var body: some View {
        Button {} label: {
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

private struct PathCardPathExistsView: View {
    let travelTime: Int
    let departureTime: String
    let arrivalTime: String
    let incomingTime: String
    let departureStation: String
    let departureStationLine: Int
    let arrivalStation: String
    let direction: String
    let finalDestination: String

    init(_ travelTime: Int, _ departureTime: String, _ arrivalTime: String, _ incomingTime: String,
         _ departureStation: String, _ departureStationLine: Int, _ arrivalStation: String, _ direction: String, _ finalDestination: String) {
        self.travelTime = travelTime
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.incomingTime = incomingTime
        self.departureStation = departureStation
        self.departureStationLine = departureStationLine
        self.arrivalStation = arrivalStation
        self.direction = direction
        self.finalDestination = finalDestination
    }

    var body: some View {
        // MARK: - 소요 시간
        Text("\(travelTime)분")
            .font(.B01_SB)
            .foregroundStyle(.scWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 6)
        HStack(spacing: 6) {
            Text("지금 도착 시")
                .font(.C01_M)
                .foregroundStyle(.gray200)
            Text("오후 \(departureTime)-\(arrivalTime)")
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
            LineNumberCircle(.init(rawValue: departureStationLine) ?? .two)
                .padding(.trailing, 4)
            Text("\(departureStation)역")
                .font(.B03_M)
                .foregroundStyle(.scWhite)
            Spacer()
        }
        HStack(alignment: .top, spacing: 0) {
            Rectangle()
                .frame(width: 1.4, height: 60)
                .foregroundStyle(.gray600)
                .padding(EdgeInsets(top: -3, leading: 5.2, bottom: -2, trailing: 46))
            Group {
                Text("\(incomingTime)")
                    .font(.C01_SB)
                    .foregroundStyle(.scGreen)
                    .padding(.trailing, 4)

                Text("\(finalDestination)행 \(direction) 방면")
                    .font(.C01_R)
                    .foregroundStyle(.gray300)
            }
            .padding(.top, 6)

            Spacer()
        }
        HStack(spacing: 0) {
            StationNodeView(.arrival)
                .padding(.trailing, 6)
            Text("하차")
                .font(.B03_M)
                .foregroundStyle(.gray400)
                .padding(.trailing, 10)
            Text("\(arrivalStation)역")
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
        Button {} label: {
            Text("바로 좌석 찾기")
                .font(.B02_B)
                .foregroundStyle(.scGreen)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
        }
    }
}

private struct PathCardPathNotExistsView: View {
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


// TODO: - 도메인 작성 후 제거
/// UI 구현 시 유저 상태를 관리하기 위한 임시 타입으로 도메인 작성 후 제거됩니다.
fileprivate enum UserStatus {
    case inTransit
    case pathExists(
        travelTime: Int,
        departureTime: String,
        arrivalTime: String,
        incomingTime: String,
        departureStation: String,
        departureStationLine: Int,
        arrivalStation: String,
        direction: String,
        finalDestination: String,
    )
    case pathNotExists

    var guidingText: String {
        switch self {
        case .inTransit:
            "현재 이용중인 경로"
        case .pathExists, .pathNotExists:
            "자주 이용한 경로"
        }
    }
}
