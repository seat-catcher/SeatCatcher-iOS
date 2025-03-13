//
//  DIContainer.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import Moya

protocol DIContainer {
    func injectPostViewModel() -> PostViewModel
}
