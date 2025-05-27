//
//  SelectPathViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/8/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class SelectPathViewModel: ViewModel {
    struct State {
        var histories: [PathHistory] = []
        var searchMode: SearchStationsMode = .departure
        var departure: Station?
        var arrival: Station?
        var searchResults: [Station] = []
        var searchText: String = ""

        var isPathSelected: Bool { departure != nil && arrival != nil }
    }

    enum Action {
        // SelectPathView
        case viewAppeared
        case swapButtonTapped
        case departureButtonTapped
        case arrivalButtonTapped
        case historyTapped(history: PathHistory)
        case nextButtonTapped

        // SearchStationsView
        case searchTextChanged(text: String)
        case searchViewBackButtonTapped
        case searchResultTapped(station: Station)
    }

    enum SearchStationsMode {
        case arrival, departure
    }

    private(set) var state = State()

    private let getPathHistoriesUseCase: GetPathHistoriesUseCase
    private let searchStationsUseCase: SearchStationsUseCase

    let coordinator: Coordinator

    let boardingState: BoardingState
    let line: Int

    @MainActor
    var searchBarPlaceholder: String {
        if boardingState == .boarded { "여기서 \(state.searchMode == .departure ? "승차역" : "하차역") 검색하기" }
        else {
            if state.searchMode == .departure { "열차의 다음 도착역 입력" }
            else { "여기서 하차역 검색하기" }
        }
    }

    public init(
        boardingState: BoardingState,
        line: Int,
        getPathHistoriesUseCase: GetPathHistoriesUseCase,
        searchStationsUseCase: SearchStationsUseCase,
        coordinator: Coordinator
    ) {
        self.boardingState = boardingState
        self.line = line
        self.getPathHistoriesUseCase = getPathHistoriesUseCase
        self.searchStationsUseCase = searchStationsUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        // SelectPathView
        case .viewAppeared:
            Task { [getPathHistoriesUseCase] in
                do {
                    let histories = try await getPathHistoriesUseCase.execute(cursor: nil)
                    self.state.histories = histories
                } catch {
                    self.state.histories = []
                }
            }
        case .swapButtonTapped:
            guard state.departure != nil, state.arrival != nil else { return }
            let temp = state.arrival
            state.arrival = state.departure
            state.departure = temp
        case .departureButtonTapped:
            state.searchMode = .departure
            coordinator.push(AppScene.searchStations(viewModel: self))
        case .arrivalButtonTapped:
            guard state.departure != nil else { return }
            state.searchMode = .arrival
            coordinator.push(AppScene.searchStations(viewModel: self))
        case .historyTapped(let history):
            state.departure = Station(id: history.departureStationId, name: history.departureStationName, line: history.line ?? 2)
            state.arrival = Station(id: history.arrivalStationId, name: history.arrivalStationName, line: history.line ?? 2)
        case .nextButtonTapped:
            guard let departure = state.departure,
                  let arrival = state.arrival
            else { return }
            coordinator.push(AppScene.selectTrain(departure: departure, arrival: arrival, boardingState: boardingState))

        // SearchStationsView
        case .searchTextChanged(let text):
            guard state.searchText != text else { return } // SwiftUI TextField Binding Setter 중복 호출 버그로 인해 방지 로직 추가
            state.searchText = text
            guard !text.isEmpty else { return } // keyword 쿼리 파라미터 빈 문자열로 호출 방지
            Task { [searchStationsUseCase] in // self 전체 메인액터 격리 방지
                do {
                    let searchResults = try await searchStationsUseCase.execute(keyword: text, line: line)
                    self.state.searchResults = searchResults
                } catch {
                    self.state.searchResults = []
                }
            }
        case .searchViewBackButtonTapped:
            state.searchText = ""
            state.searchResults = []
        case .searchResultTapped(let station):
            switch state.searchMode {
            case .departure:
                if state.departure == nil { state.departure = station }
                else { state.departure = nil }
            case .arrival:
                if state.arrival == nil { state.arrival = station }
                else { state.arrival = nil }
            }
            self.action(.searchViewBackButtonTapped)
            coordinator.pop()
        }
    }
}
