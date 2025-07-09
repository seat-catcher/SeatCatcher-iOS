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
            .init(title: "즐거운 짐꾼", time: Date().addingTimeInterval(-3600), message: "즐거운 짐꾼님이 3847칸 일반구역 B에서 좌석 요청을 했어요"),
            .init(title: "열받은 노약자", time: Date().addingTimeInterval(-1284), message: "열받은 노약자님이 9183칸 일반구역 B에서 좌석 요청을 했어요")
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
