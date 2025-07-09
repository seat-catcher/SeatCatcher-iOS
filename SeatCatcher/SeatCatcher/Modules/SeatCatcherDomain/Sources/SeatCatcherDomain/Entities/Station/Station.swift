//
//  Station.swift
//  SeatCatcherDomain
//
//  Created by 박현수 on 5/7/25.
//

public struct Station: Sendable, Identifiable {
    public let id: Int
    public let name: String
    public let line: Int

    public init(id: Int, name: String, line: Int) {
        self.id = id
        self.name = name
        self.line = line
    }
}
