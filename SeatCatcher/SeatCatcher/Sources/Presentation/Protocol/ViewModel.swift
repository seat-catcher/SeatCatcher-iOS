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

    var state: State { get }

    func action(_ action: Action)
}
