//
//  DIContainer.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SeatCatcherDomain
import SeatCatcherCore

public protocol DIContainer {
    // MARK: - Auth UseCases
    func resolveAppleLoginUseCase() -> AppleLoginUseCase
    func resolveKakaoLoginUseCase() -> KakaoLoginUseCase
    func resolveValidateTokenUseCase() -> ValidateTokenUseCase
    func resolveLogoutUseCase() -> LogoutUseCase

    // MARK: - User UseCases
    func resolveGetRandomNicknameUseCase() -> GetRandomNicknameUseCase
    func resolveGetRandomUserImageUseCase() -> GetRandomUserImageUseCase
    func resolveGetUserInfoUseCase() -> GetUserInfoUseCase
    func resolvePatchUserInfoUseCase() -> PatchUserInfoUseCase

    // MARK: - Station UseCases
    func resolveSearchDepartureStationsUseCase() -> SearchDepartureStationsUseCase
    func resolveSearchArrivalStationsUseCase() -> SearchArrivalStationsUseCase

    // MARK: - Store
    func resolveAppStore() -> AppStore
}
