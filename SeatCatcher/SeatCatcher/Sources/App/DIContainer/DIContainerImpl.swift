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
    private lazy var searchDepartureStationsUseCase = SearchDepartureStationsUseCaseImpl(stationsRepository: stationsRepository)
    private lazy var searchArrivalStationsUseCase = SearchArrivalStationsUseCaseImpl(stationsRepository: stationsRepository)
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
    func resolveSearchDepartureStationsUseCase() -> SearchDepartureStationsUseCase { return searchDepartureStationsUseCase }
    func resolveSearchArrivalStationsUseCase() -> SearchArrivalStationsUseCase { return searchArrivalStationsUseCase }

    // MARK: - Store
    func resolveAppStore() -> AppStore { return appStore }
}
