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

    }

    struct State {

    }

    let store: AppStore
    let coordinator: Coordinator

    public init(store: AppStore, coordinator: Coordinator) {
        self.store = store
        self.coordinator = coordinator
    }

    private(set) var state = State()

    func action(_ action: Action) {

    }
}
