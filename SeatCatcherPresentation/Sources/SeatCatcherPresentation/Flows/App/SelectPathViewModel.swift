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
        var searchMode: SearchStationsMode = .departure
        var departure: Station?
        var arrival: Station?
        var searchResults: [Station] = []
        var searchText: String = ""
    }

    enum Action {
        case swapButtonTapped
        case departureButtonTapped
        case arrivalButtonTapped
        case searchTextChanged(text: String)
        case backButtonTapped
        case searchResultTapped(station: Station)
    }

    enum SearchStationsMode {
        case arrival, departure
    }

    private(set) var state = State()

    private let searchDepartureStationsUseCase: SearchDepartureStationsUseCase
    private let searchArrivalStationsUseCase: SearchArrivalStationsUseCase

    let coordinator: Coordinator

    public init(
        searchDepartureStationsUseCase: SearchDepartureStationsUseCase,
        searchArrivalStationsUseCase: SearchArrivalStationsUseCase,
        coordinator: Coordinator
    ) {
        self.searchDepartureStationsUseCase = searchDepartureStationsUseCase
        self.searchArrivalStationsUseCase = searchArrivalStationsUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
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
        case .searchTextChanged(let text):
            guard state.searchText != text else { return } // SwiftUI TextField Binding Setter 중복 호출 버그로 인해 방지 로직 추가
            state.searchText = text
            guard !text.isEmpty else { return } // keyword 쿼리 파라미터 빈 문자열로 호출 방지
            Task { [searchDepartureStationsUseCase, searchArrivalStationsUseCase] in // self 전체 메인액터 격리 방지
                switch state.searchMode {
                case .departure:
                    let searchResults = try await searchDepartureStationsUseCase.execute(keyword: text)
                    self.state.searchResults = searchResults
                case .arrival:
                    guard let line = state.departure?.line else { return }
                    let searchResults = try await searchArrivalStationsUseCase.execute(keyword: text, line: line)
                    self.state.searchResults = searchResults
                }
            }
        case .backButtonTapped:
            if state.searchMode == .departure { state.departure = nil }
            state.arrival = nil
            state.searchText = ""
            state.searchResults = []
        case .searchResultTapped(let station):
            switch state.searchMode {
            case .departure:
                state.departure = station
            case .arrival:
                state.arrival = station
            }
            self.action(.backButtonTapped)
            coordinator.pop()
        }
    }
}
