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

    let userStore: UserStore

    public init(userStore: UserStore) {
        self.userStore = userStore
    }

    private(set) var state = State()

    func action(_ action: Action) {

    }

    func changeUserImage() {
        userStore.user.profileImage = UserImage.allCases.randomElement()!
    }
}
