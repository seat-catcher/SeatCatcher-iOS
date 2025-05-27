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
        var trainCode: String
        var carCode: String
        var selectedOption: ManageSeatOption?
    }
    
    // MARK: Dependencies
    let store: AppStore
    let coordinator: Coordinator
    private(set) var state: State
    
    @MainActor
    public init(
        store: AppStore,
        coordinator: Coordinator,
        trainCode: String,
        carCode: String
    ) {
        self.store = store
        self.coordinator = coordinator
        self.state = .init(trainCode: trainCode, carCode: carCode, selectedOption: nil)
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
                    AppScene.mainFeatureRegisterSeat(trainCode: state.trainCode, carCode: state.carCode)
                case .move:
                    AppScene.mainFeatureMoveSeat(trainCode: state.trainCode, carCode: state.carCode)
                case .cancel:
                    AppScene.mainFeatureCancelSeat(trainCode: state.trainCode, carCode: state.carCode)
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
