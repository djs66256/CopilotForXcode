//
//  IPCProtocol.swift
//  SocketIPC
//
//  Created by daniel on 2025/1/13.
//

public protocol IPCProtocol {
    associatedtype RequestType: Codable
    associatedtype ResponseType: Codable
    static var messageType: String { get }
}

public protocol FromCoreToXcodeIPCProtocol: IPCProtocol {}

public protocol FromXcodeToCoreIPCProtocol: IPCProtocol {}
