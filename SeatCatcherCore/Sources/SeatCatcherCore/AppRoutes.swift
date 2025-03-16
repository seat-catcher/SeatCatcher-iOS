//
//  AppRoutes.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/14/25.
//

import Foundation

/// Core 모듈에서 정의하는 루트 추상화입니다.
public protocol AppRoute: Hashable, Identifiable {
    var id: String { get }
}
