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

    let store: AppStore
    private let getRandomNicknameUseCase: GetRandomNicknameUseCase
    private let patchUserInfoUseCase: PatchUserInfoUseCase
    let coordinator: Coordinator
    private(set) var state: State
    
    public init(store: AppStore, coordinator: Coordinator, getRandomNicknameUseCase: GetRandomNicknameUseCase, patchUserInfoUseCase: PatchUserInfoUseCase) {
        self.store = store
        self.state = .init(nickname: store.user.name, profileImage: store.user.profileImage)
        self.getRandomNicknameUseCase = getRandomNicknameUseCase
        self.patchUserInfoUseCase = patchUserInfoUseCase
        self.coordinator = coordinator
    }

    func action(_ action: Action) {
        switch action {
        case .willSetNewNickname:
            let updatedUser = User(
                id: store.user.id,
                name: getRandomNicknameUseCase.execute(),
                profileImage: store.user.profileImage,
                tags: store.user.tags,
                credit: store.user.credit,
                hasOnBoarded: store.user.hasOnBoarded
            )
            Task { [patchUserInfoUseCase] in
                do {
                    try await patchUserInfoUseCase.execute(updatedUser)
                    store.setUser(updatedUser)
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
                id: store.user.id,
                name: getRandomNicknameUseCase.execute(),
                profileImage: image,
                tags: store.user.tags,
                credit: store.user.credit,
                hasOnBoarded: store.user.hasOnBoarded
            )
            Task { [patchUserInfoUseCase] in
                do {
                    try await patchUserInfoUseCase.execute(updatedUser)
                    store.setUser(updatedUser)
                } catch {
                    dump(error.localizedDescription)
                }
            }
        }
    }
}
