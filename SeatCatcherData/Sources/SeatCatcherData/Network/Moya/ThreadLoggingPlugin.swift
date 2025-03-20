//
//  ThreadLoggingPlugin.swift
//  SeatCatcherData
//
//  Created by 박현수 on 3/16/25.
//

import Foundation
import Moya

final class ThreadLoggingPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        dump("Request: \(Thread.current) | isMainThread: \(Thread.isMainThread)")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        dump("Response: \(Thread.current) | isMainThread: \(Thread.isMainThread)")
    }
}
