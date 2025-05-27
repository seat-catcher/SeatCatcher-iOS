//
//  DIContainerImpl.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/13/25.
//

import Foundation
import Moya
import SeatCatcherDomain
import SeatCatcherCore
import SeatCatcherData

final class DIContainerImpl {
    // MARK: - Store Instances
    private let appStore = AppStore(user: User(hasOnBoarded: true))

    // MARK: - Service Instances
    private let networkService = NetworkService()

    // MARK: - Repository Instances
    private lazy var loginRepository = LoginRepositoryImpl(networkService: networkService)
    private lazy var tokenRepository = TokenRepositoryImpl(networkService: networkService)
    private lazy var userRepository = UserRepositoryImpl(networkService: networkService)
    private lazy var stationsRepository = StationsRepositoryImpl(networkService: networkService)
    private lazy var pathHistoriesRepository = PathHistoriesRepositoryImpl(networkService: networkService)
    private lazy var seatRepository = SeatRepositoryImpl(networkService: networkService)

    // MARK: - Auth UseCase Instances
    private lazy var appleLoginUseCase = AppleLoginUseCaseImpl(
        loginRepository: loginRepository,
        tokenRepository: tokenRepository,
        userRepository: userRepository
    )
    private lazy var kakaoLoginUseCase = KakaoLoginUseCaseImpl(
        loginRepository: loginRepository,
        tokenRepository: tokenRepository,
        userRepository: userRepository
    )
    private lazy var validateTokenUseCase = ValidateTokenUseCaseImpl(
        tokenRepository: tokenRepository
    )
    private lazy var logoutUseCase = LogoutUseCaseImpl(
        tokenRepository: tokenRepository,
        userRepository: userRepository
    )

    // MARK: - User UseCase Instances
    private lazy var getRandomNicknameUseCase = GetRandomNicknameUseCaseImpl(userRepository: userRepository)
    private lazy var getRandomUserImageUseCase = GetRandomUserImageUseCaseImpl(userRepository: userRepository)
    private lazy var getUserInfoUseCase = GetUserInfoUseCaseImpl(userRepository: userRepository)
    private lazy var patchUserInfoUseCase = PatchUserInfoUseCaseImpl(userRepository: userRepository)

    // MARK: - Stations UseCase Instances
    private lazy var searchStationsUseCase = SearchStationsUseCaseImpl(stationsRepository: stationsRepository)
    
    // MARK: - Seat UseCases Instances
    private lazy var getSeatInTrainCarUseCase = GetSeatInTrainCarUseCaseImpl(seatRepository: seatRepository)
    private lazy var getSeatInSectionUseCase = GetSeatInSectionUseCaseImpl()
    private lazy var unlockSeatUseCase = UnlockSeatUseCaseImpl(seatRepository: seatRepository)
    private lazy var registerSeatUseCase: RegisterSeatUseCase = RegisterSeatUseCaseImpl(seatRepository: seatRepository)
    private lazy var moveSeatUseCase: MoveSeatUseCase = MoveSeatUseCaseImpl(seatRepository: seatRepository)
    private lazy var cancelSeatUseCase: CancelSeatUseCase = CancelSeatUseCaseImpl(seatRepository: seatRepository)
    
    // MARK: - PathHistories UseCase Instances
    private lazy var getPathHistoriesUseCase = GetPathHistoriesUseCaseImpl(pathHistoriesRepository: pathHistoriesRepository)
    private lazy var postPathHistoriesUseCase = PostPathHistoriesImpl(pathHistoriesRespotiry: pathHistoriesRepository)
}

// MARK: - DIContainer 프로토콜 구현
extension DIContainerImpl: DIContainer {
    // MARK: - Auth UseCases
    func resolveAppleLoginUseCase() -> AppleLoginUseCase { return appleLoginUseCase }
    func resolveKakaoLoginUseCase() -> KakaoLoginUseCase { return kakaoLoginUseCase }
    func resolveValidateTokenUseCase() -> ValidateTokenUseCase { return validateTokenUseCase }
    func resolveLogoutUseCase() -> LogoutUseCase { return logoutUseCase }

    // MARK: - User UseCases
    func resolveGetRandomNicknameUseCase() -> GetRandomNicknameUseCase { return getRandomNicknameUseCase }
    func resolveGetRandomUserImageUseCase() -> GetRandomUserImageUseCase { return getRandomUserImageUseCase }
    func resolveGetUserInfoUseCase() -> GetUserInfoUseCase { return getUserInfoUseCase }
    func resolvePatchUserInfoUseCase() -> PatchUserInfoUseCase { return patchUserInfoUseCase }

    // MARK: - Station UseCases
    func resolveSearchStationsUseCase() -> SearchStationsUseCase { return searchStationsUseCase }

    // MARK: - PathHistories UseCases
    func resolveGetPathHistoriesUseCase() ->  GetPathHistoriesUseCase { return getPathHistoriesUseCase }
    func resolvePostPathHistoriesUseCase() -> PostPathHistoriesUseCase { return postPathHistoriesUseCase }
    
    // MARK: - Seat UseCases
    func resolveGetSeatInTrainCarUseCase() -> GetSeatInTrainCarUseCase { return getSeatInTrainCarUseCase }
    func resolveGetSeatInSectionUseCase() -> GetSeatInSectionUseCase { return getSeatInSectionUseCase }
    func resolveUnlockSeatUseCase() -> UnlockSeatUseCase { return unlockSeatUseCase }
    func resolveRegisterSeatUseCase() -> RegisterSeatUseCase { return registerSeatUseCase }
    func resolveMoveSeatUseCase() -> MoveSeatUseCase { return moveSeatUseCase }
    func resolveCancelSeatUseCase() -> CancelSeatUseCase { return cancelSeatUseCase }

    // MARK: - Store
    func resolveAppStore() -> AppStore { return appStore }
}
