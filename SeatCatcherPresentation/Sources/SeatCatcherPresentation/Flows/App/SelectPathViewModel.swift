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
        var searchText: String = ""
    }

    enum Action {
        case swapButtonTapped
        case departureButtonTapped
        case arrivalButtonTapped
        case searchTextChanged(text: String)
    }

    enum SearchStationsMode {
        case arrival, departure
    }

    private(set) var state = State()
    let coordinator: Coordinator

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .swapButtonTapped:
            let temp = state.arrival
            state.arrival = state.departure
            state.departure = temp
        case .departureButtonTapped:
            state.searchMode = .departure
            coordinator.push(AppScene.searchStations(viewModel: self))
        case .arrivalButtonTapped:
            state.searchMode = .arrival
            coordinator.push(AppScene.searchStations(viewModel: self))
        case .searchTextChanged(let text):
            guard state.searchText != text else { return } // SwiftUI TextField Binding Setter 중복 호출 버그로 인해 방지 로직 추가
            state.searchText = text
            dump(text)
            break
        }
    }
}
