//
//  MainFeatureViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/16/25.
//

import Foundation
import SeatCatcherCore

@Observable
public final class MainFeatureViewModel: ViewModel {
    enum Action {

    }

    struct State {

    }

    let userStore: UserStore

    public init(userStore: UserStore) {
        self.userStore = userStore
    }

    private(set) var state = State()

    func action(_ action: Action) {

    }
}
