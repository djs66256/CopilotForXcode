//
//  Types.swift
//  SocketIPC
//
//  Created by daniel on 2025/1/13.
//

import Foundation

public struct Position: Codable, Sendable {
    public let line: Int
    public let character: Int
    public init(line: Int, character: Int) {
        self.line = line
        self.character = character
    }
}

public struct Range: Codable, Sendable {
    public let start: Position
    public let end: Position
    public init(start: Position, end: Position) {
        self.start = start
        self.end = end
    }
}
