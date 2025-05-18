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

    let appStore: AppStore

    public init(appStore: AppStore) {
        self.appStore = appStore
    }

    private(set) var state = State()

    func action(_ action: Action) {

    }
}
