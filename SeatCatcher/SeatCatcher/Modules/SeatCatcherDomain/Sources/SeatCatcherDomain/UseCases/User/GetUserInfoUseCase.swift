//
//  GetUserInfoUseCase.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 4/17/25.
//

public protocol GetUserInfoUseCase {
    func execute() async throws -> User
}

public final class GetUserInfoUseCaseImpl: GetUserInfoUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    /// /user/me GET API에서 아직 온보딩(/user/me PATCH)이 진행되지 않은 경우 Default Value를 반환하므로,
    /// 온보딩 여부가 true일 경우 서버에 담긴 유저 정보를, false일 경우 정보가 설정되지 않은 상태의 hasOnBoarded가 false인 User 인스턴스를 생성하여 반환합니다.
    public func execute() async throws -> User {
        let user = try await userRepository.getUser()
        if user.hasOnBoarded { return user }
        else { return User(hasOnBoarded: false) }
    }
}
