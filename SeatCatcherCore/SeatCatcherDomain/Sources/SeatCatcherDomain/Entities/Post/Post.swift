//
//  Post.swift
//  SeatCatcher
//
//  Created by 박현수 on 3/12/25.
//

import Foundation

public struct Post: Sendable, Identifiable {
    public let id: Int
    public let title: String
    public let content: String

    public init(id: Int, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
