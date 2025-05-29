//
//  SelectSeatSectionViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/28/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

@Observable
public final class SelectSeatSectionViewModel: ViewModel {
    struct State {
        var selectedOption: SeatSectionType?
        var carCode: String
        var carDirection: CarDirection
        var availableSections: [SeatSectionType]
    }
    
    enum Action {
        case willAppear
        case willSelectOption(SeatSectionType)
        case didSelectOption
    }
    
    private(set) var state: State
    
    let store: AppStore
    let coordinator: Coordinator
    
    private let getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase
    
    @MainActor
    public init(
        store: AppStore,
        coordinator: Coordinator,
        getSeatInTrainCarUseCase: GetSeatInTrainCarUseCase
        
    ) {
        self.store = store
        self.coordinator = coordinator
        self.getSeatInTrainCarUseCase = getSeatInTrainCarUseCase
        self.state = .init(
            carCode: store.carCode ?? "NNNN",
            carDirection: store.carDirection ?? .up,
            availableSections: [] // 초기 상태
        )
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            guard let trainCode = store.trainCode,
                  let carCode = store.carCode else {
                state.availableSections = []
                return
            }
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                let trainCar = try await self.getSeatInTrainCarUseCase.execute(
                    trainCode: trainCode,
                    carCode: carCode
                )
                // occupant가 있는 section만 포함
                let availableSections = trainCar.seatInfo.compactMap { (sectionType, seatSection) -> SeatSectionType? in
                    let hasAvailableSeat = seatSection.topSeats.values.contains { $0.occupant != nil } ||
                    seatSection.bottomSeats.values.contains { $0.occupant != nil }
                    return hasAvailableSeat ? sectionType : nil
                }
                // availableSections 업데이트
                self.state.availableSections = availableSections
            }
        case let .willSelectOption(option):
            if option == self.state.selectedOption {
                self.state.selectedOption = nil
            } else {
                self.state.selectedOption = option
            }
        case .didSelectOption:
            store.seatSectionType = self.state.selectedOption
            coordinator.push(AppScene.mainFeature)
        }
    }
}
