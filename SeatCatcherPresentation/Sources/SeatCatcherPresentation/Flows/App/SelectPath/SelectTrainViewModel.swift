//
//  SelectTrainViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/27/25.
//

import Foundation
import SeatCatcherDomain

@Observable
public final class SelectTrainViewModel: ViewModel {
    struct State {

    }
    enum Action {

    }

    let departure: Station
    let arrival: Station

    private(set) var state = State()

    public init(departure: Station, arrival: Station) {
        self.departure = departure
        self.arrival = arrival
    }

    func action(_ action: Action) {

    }
}
