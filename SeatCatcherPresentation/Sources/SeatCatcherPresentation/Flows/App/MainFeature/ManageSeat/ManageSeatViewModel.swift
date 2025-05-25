//
//  ManageSeatViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/25/25.
//

import Foundation
import SwiftUI
import SeatCatcherCore

@Observable
public class ManageSeatViewModel: ViewModel {
    enum Action {
        case willSelectOption(ManageSeatOption)
        case didSelectOption
        case backButtonDidTap
        case homeButtonDidTap
    }
    
    enum ManageSeatOption: String, CaseIterable {
        case register = "앉은좌석 등록하기"
        case move = "앉은좌석 이동하기"
        case cancel = "앉은좌석 취소하기"
        
        var icon: ImageResource {
            switch self {
            case .register:
                return .iconRegister
            case .move:
                return .iconMove
            case .cancel:
                return .iconCancel
            }
        }
    }
    
    struct State {
        var selectedOption: ManageSeatOption?
    }
    
    // MARK: Dependencies
    let store: AppStore
    let coordinator: Coordinator
    private(set) var state = State(selectedOption: nil)
    
    public init(
        store: AppStore,
        coordinator: Coordinator
    ) {
        self.store = store
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .willSelectOption(let option):
            if option == state.selectedOption {
                state.selectedOption = nil // 재탭
            } else {
                state.selectedOption = option // 변경
            }
        case .didSelectOption:
            if let option = state.selectedOption {
                let scene = switch option {
                case .register:
                    AppScene.mainFeatureRegisterSeat
                case .move:
                    AppScene.mainFeatureMoveSeat
                case .cancel:
                    AppScene.mainFeatureCancelSeat
                }
                coordinator.push(scene)
            }
        case .backButtonDidTap:
            coordinator.pop()
        case .homeButtonDidTap:
            coordinator.popToRoot()
        }
    }
}
