//
//  MypageProfileChangeViewModel.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 7/2/25.
//

import Foundation
import SeatCatcherCore
import SeatCatcherDomain

public final class MypageProfileChangeViewModel: ViewModel {
    struct State {
        var nickname: String
        var didChangeNickname: Bool = false
        var profileImage: UserImage
        var selectedProfileImage: UserImage?
    }
    
    enum Action {
        case willSetNewNickname
        case didTapprofileimageChangeButton
        case WillSetProfileImage(UserImage)
    }

    let appStore: AppStore
    private let getRandomNicknameUseCase: GetRandomNicknameUseCase
    private let patchUserInfoUseCase: PatchUserInfoUseCase
    let coordinator: Coordinator
    private(set) var state: State
    
    public init(appStore: AppStore, coordinator: Coordinator, getRandomNicknameUseCase: GetRandomNicknameUseCase, patchUserInfoUseCase: PatchUserInfoUseCase) {
        self.appStore = appStore
        self.state = .init(nickname: appStore.user.name, profileImage: appStore.user.profileImage)
        self.getRandomNicknameUseCase = getRandomNicknameUseCase
        self.patchUserInfoUseCase = patchUserInfoUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .willSetNewNickname:
            let updatedUser = User(
                id: appStore.user.id,
                name: getRandomNicknameUseCase.execute(),
                profileImage: appStore.user.profileImage,
                tags: appStore.user.tags,
                credit: appStore.user.credit,
                hasOnBoarded: appStore.user.hasOnBoarded
            )
            Task {
                do {
                    try await self.patchUserInfoUseCase.execute(updatedUser)
                    appStore.setUser(updatedUser)
                    state.didChangeNickname = true
                } catch {
                    dump(error.localizedDescription)
                }
            }
        case .didTapprofileimageChangeButton:
            coordinator.presentSheet(
                AppSheet.profileImageChange(viewModel: self),
                onDismiss: { }
            )
        case let .WillSetProfileImage(image):
            let updatedUser = User(
                id: appStore.user.id,
                name: getRandomNicknameUseCase.execute(),
                profileImage: image,
                tags: appStore.user.tags,
                credit: appStore.user.credit,
                hasOnBoarded: appStore.user.hasOnBoarded
            )
            Task {
                do {
                    try await self.patchUserInfoUseCase.execute(updatedUser)
                    appStore.setUser(updatedUser)
                } catch {
                    dump(error.localizedDescription)
                }
            }
        }
    }
}
