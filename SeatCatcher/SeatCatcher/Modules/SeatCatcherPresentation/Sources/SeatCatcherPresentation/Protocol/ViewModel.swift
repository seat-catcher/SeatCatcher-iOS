//
//  ViewModel.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation
import SeatCatcherCore

protocol ViewModel {
    associatedtype State
    associatedtype Action

    @MainActor var state: State { get }
    @MainActor func action(_ action: Action)
}
