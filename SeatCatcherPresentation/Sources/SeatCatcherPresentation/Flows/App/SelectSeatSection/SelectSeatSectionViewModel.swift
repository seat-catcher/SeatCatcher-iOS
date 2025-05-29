//
//  SelectSeatSectionViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/28/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class SelectSeatSectionViewModel: ViewModel {
    struct State {
        var selectedOption: SeatSectionType?
        var carCode: String
        var carDirection: CarDirection
        var availableSections: [SeatSectionType]
    }
    
    public enum CarDirection: String {
        case up = "위쪽"
        case down = "아래쪽"
    }

    enum Action {
        case willSelectOption(SeatSectionType)
        case didSelectOption
    }

    private(set) var state: State

    let store: AppStore
    let coordinator: Coordinator

    @MainActor
    public init(
        store: AppStore,
        coordinator: Coordinator,
        carDirection: CarDirection
    ) {
        self.store = store
        self.coordinator = coordinator
        self.state = .init(
            carCode: store.carCode ?? "NNNN",
            carDirection: carDirection,
            availableSections: [] // 초기 상태
        )
    }

    func action(_ action: Action) {
        switch action {
        case let .willSelectOption(option):
            if option == self.state.selectedOption {
                self.state.selectedOption = nil
            } else {
                self.state.selectedOption = option
            }
        case .didSelectOption:
            store.seatSectionType = self.state.selectedOption
            coordinator.push(AppScene.mainFeature(hasSeated: false)) // FIXME: 수정 필요
        }
    }
}
