//
//  IPCProtocol.swift
//  SocketIPC
//
//  Created by daniel on 2025/1/13.
//

public protocol IPCProtocol {
    associatedtype FromType: Codable
    associatedtype ToType: Codable
    static var messageType: String { get }
}
