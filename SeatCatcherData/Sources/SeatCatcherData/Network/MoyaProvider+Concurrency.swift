//
//  MoyaProvider+Concurrency.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation
import Moya

extension MoyaProvider {
    /**
     Swift Concurrency (async/await) 지원을 위한 MoyaProvider 익스텐션
     비동기 Context 내부 Sendable을 보장하기 위해 Response Data만 추출해 반환합니다.
     ## 동작 방식
     1. `withCheckedThrowingContinuation`을 사용하여 Task를 suspend(일시 정지) 상태로 만듦
     2. `self.request(target) { result in ... }`을 호출하여 네트워크 요청 실행
     3. 요청이 완료되면 (`result`가 반환되면) Task의 suspend를 해제 (`resume()`)
     4. 성공 시 `Response` 객체를 반환, 실패 시 `MoyaError`를 throw
    */
    func request(_ target: Target) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
