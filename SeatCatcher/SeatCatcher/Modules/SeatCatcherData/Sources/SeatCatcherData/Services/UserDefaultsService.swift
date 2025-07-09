//
//  UserDefaultsService.swift
//  SeatCatcherData
//
//  Created by 박현수 on 4/10/25.
//

import Foundation

/// UserDefaults를 관리하기 위한 Service입니다.
struct UserDefaultsService: Sendable {
    static var isSignedIn: Bool {
        get { UserDefaults.standard.bool(forKey: "isSignedIn") }
        set { UserDefaults.standard.set(newValue, forKey: "isSignedIn") }
    }
}
