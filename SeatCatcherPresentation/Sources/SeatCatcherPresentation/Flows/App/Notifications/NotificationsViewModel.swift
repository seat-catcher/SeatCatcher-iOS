//
//  NotificationsViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/6/25.
//

import Foundation
import SeatCatcherCore

@Observable
public final class NotificationsViewModel: ViewModel {
    struct State {
        var notifications: [NotificationInfo] = [
            .init(title: "test", time: Date(), message: "test"),
        ]
    }

    enum Action {}

    private(set) var state = State()

    let coordinator: Coordinator

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func action(_ action: Action) {}
}
