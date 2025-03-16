//
//  ViewModel.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

protocol ViewModel {
    associatedtype Action
    associatedtype State

    @MainActor var state: State { get }

    @MainActor func action(_ action: Action)
}
