//
//  DIContainer.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import SeatCatcherDomain

public protocol DIContainer {
    // MARK: - Auth UseCases
    func resolveAppleLoginUseCase() -> AppleLoginUseCase
    func resolveKakaoLoginUseCase() -> KakaoLoginUseCase
    func resolveValidateTokenUseCase() -> ValidateTokenUseCase
    func resolveLogoutUseCase() -> LogoutUseCase
    func resolveSaveFCMTokenUseCase() -> SaveFCMTokenUseCase
    func resolveWithdrawUseCase() -> WithdrawUseCase

    // MARK: - User UseCases
    func resolveGetRandomNicknameUseCase() -> GetRandomNicknameUseCase
    func resolveGetRandomUserImageUseCase() -> GetRandomUserImageUseCase
    func resolveGetUserInfoUseCase() -> GetUserInfoUseCase
    func resolvePatchUserInfoUseCase() -> PatchUserInfoUseCase

    // MARK: - Station UseCases
    func resolveSearchStationsUseCase() -> SearchStationsUseCase
    func resolveGetStationUseCase() -> GetStationUseCase

    // MARK: - PathHistories UseCases
    func resolveGetPathHistoriesUseCase() -> GetPathHistoriesUseCase
    func resolvePostPathHistoriesUseCase() -> PostPathHistoriesUseCase
    func resolveStartJourneyUseCase() -> StartJourneyUseCase
    func resolveSubscribeArrivalTimeUseCase() -> SubscribeArrivalTimeUseCase

    // MARK: - Seat UseCases
    func resolveGetSeatInTrainCarUseCase() -> GetSeatInTrainCarUseCase
    func resolveGetSeatInSectionUseCase() -> GetSeatInSectionUseCase
    func resolveUnlockSeatUseCase() -> UnlockSeatUseCase
    func resolveRegisterSeatUseCase() -> RegisterSeatUseCase
    func resolveMoveSeatUseCase() -> MoveSeatUseCase
    func resolveCancelSeatUseCase() -> CancelSeatUseCase
    func resolveSubscribeTrainUseCase() -> SubscribeTrainUseCase
    func resolveRequestSeatUseCase() -> RequestSeatUseCase
    func resolveCancelRequestSeatUseCase() -> CancelRequestSeatUseCase
    func resolveAcceptRequestSeatUseCase() -> AcceptRequestSeatUseCase
    func resolveRejectRequestSeatUseCase() -> RejectRequestSeatUseCase
    func resolveReceiveSeatUseCase() -> ReceiveSeatUseCase

    // MARK: - Incoming UseCases
    func resolveGetIncomingsUseCase() -> GetIncomingsUseCase

    // MARK: - Store
    func resolveAppStore() -> AppStore
}
