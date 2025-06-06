//
//  HomeViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 4/14/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class HomeViewModel: ViewModel {
    enum Action {
        case viewWillAppear
        case quickBoardingButtonTapped
        case catchSeatButtonTapped
        case notificationButtonTapped
        case userInfoCardTapped
        case creditStoreButtonTapped
        case alertPrimaryButtonTapped
    }

    struct State {
        let store: AppStore
        enum UserStatus {
            case inTransit
            case pathExists
            case pathNotExists
        }

        var isCreditStoreAlertPresented = false
        var pathHistory: PathHistory?
        var incoming: Incoming?

        var userStatus: UserStatus {
            if store.isOnJourney { .inTransit }
            else if pathHistory == nil { .pathNotExists }
            else { .pathExists }
        }

        var guidingText: String {
            switch userStatus {
            case .inTransit: "현재 이용중인 경로"
            case .pathExists, .pathNotExists: "자주 이용한 경로"
            }
        }

        var expectedRemainingTime: TimeInterval? {
            store.expectedArrivalTime?.timeIntervalSinceNow
        }

        var totalTimeInterval: TimeInterval? {
            store.expectedArrivalTime?.timeIntervalSince(store.departureTime ?? Date())
        }
    }

    let store: AppStore
    let getPathHistoriesUseCase: GetPathHistoriesUseCase
    let getStationUseCase: GetStationUseCase
    let getIncomingsUseCase: GetIncomingsUseCase
    let coordinator: Coordinator

    private(set) var state: State

    @MainActor
    public init(
        store: AppStore,
        getPathHistoriesUseCase: GetPathHistoriesUseCase,
        getStationUseCase: GetStationUseCase,
        getIncomingsUseCase: GetIncomingsUseCase,
        coordinator: Coordinator
    ) {
        self.store = store
        self.getPathHistoriesUseCase = getPathHistoriesUseCase
        self.getStationUseCase = getStationUseCase
        self.getIncomingsUseCase = getIncomingsUseCase
        self.coordinator = coordinator

        self.state = State(store: store)
    }

    func action(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task {
                guard let pathHistories = try? await getPathHistoriesUseCase.execute(),
                      let firstHistory = pathHistories.first,
                      let departure = try? await getStationUseCase.execute(id: firstHistory.departureStationId),
                      let arrival = try? await getStationUseCase.execute(id: firstHistory.arrivalStationId),
                      let incoming = try? await getIncomingsUseCase.execute(departure: departure, arrival: arrival),
                      let firstIncoming = incoming.first
                else { return }

                await MainActor.run {
                    state.pathHistory = firstHistory
                    state.incoming = firstIncoming
                }
            }
        case .quickBoardingButtonTapped:
            if store.isOnJourney {
                coordinator.push(AppScene.mainFeature)
            } else {
                Task { [getStationUseCase] in
                    guard let pathHistory = state.pathHistory,
                          let departure = try? await getStationUseCase.execute(id: pathHistory.departureStationId),
                          let arrival = try? await getStationUseCase.execute(id: pathHistory.arrivalStationId),
                          let incoming = state.incoming
                    else { return }

                    await MainActor.run {
                        coordinator.push(
                            AppScene.inputCarCode(
                                departure: departure,
                                arrival: arrival,
                                incoming: incoming
                            )
                        )
                    }
                }
            }
        case .catchSeatButtonTapped:
            if store.isOnJourney { coordinator.push(AppScene.selectBoardingState) }
            else { coordinator.push(AppScene.mainFeature) }
        case .notificationButtonTapped:
            coordinator.push(AppScene.notifications)
        case .userInfoCardTapped:
            coordinator.push(AppScene.mypage)
        case .creditStoreButtonTapped:
            state.isCreditStoreAlertPresented = true
        case .alertPrimaryButtonTapped:
            state.isCreditStoreAlertPresented = false
        }
    }
}
