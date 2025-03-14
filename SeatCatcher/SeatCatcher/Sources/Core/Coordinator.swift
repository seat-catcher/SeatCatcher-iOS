//
//  Coordinator.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SwiftUI

/// Navigation 화면 전환을 관리하는 객체의 프로토콜입니다.
protocol Coordinator: AnyObject {
    var diContainer: DIContainer { get set }
    var path: NavigationPath { get set }
    var sheet: AppSheet? { get set }
    var fullScreenCover: AppFullScreenCover? { get set }
    var sheetOnDismiss: (() -> Void)? { get set }
    var fullScreenCoverOnDismiss: (() -> Void)? { get set }

    func push(_ scene: AppScene)
    func pop()
    func popToRoot()
    func presentSheet(_ sheet: AppSheet, onDismiss: (() -> Void)?)
    func dismissSheet()
    func presentFullScreenCover(
        _ fullScreenCover: AppFullScreenCover,
        onDismiss: (() -> Void)?
    )
    func dismissFullScreenCover()
}

// MARK: - 기본 구현 제공
extension Coordinator {
    func push(_ scene: AppScene) {
        path.append(scene)
    }

    func pop() {
        if !path.isEmpty { path.removeLast() }
    }

    func popToRoot() {
        if !path.isEmpty { path.removeLast(path.count - 1) }
    }

    func presentSheet(_ sheet: AppSheet, onDismiss: (() -> Void)? = nil) {
        self.sheet = sheet
        self.sheetOnDismiss = onDismiss
    }

    func dismissSheet() {
        self.sheet = nil
        if let onDismiss = sheetOnDismiss { onDismiss() }
        self.sheetOnDismiss = nil
    }

    func presentFullScreenCover(
        _ fullScreenCover: AppFullScreenCover,
        onDismiss: (() -> Void)? = nil
    ) {
        self.fullScreenCover = fullScreenCover
        self.fullScreenCoverOnDismiss = onDismiss
    }

    func dismissFullScreenCover() {
        self.fullScreenCover = nil
        if let onDismiss = fullScreenCoverOnDismiss { onDismiss() }
        self.fullScreenCoverOnDismiss = nil
    }
}



