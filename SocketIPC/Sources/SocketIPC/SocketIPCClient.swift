//
//  SocketIPCClient.swift
//  SocketIPC
//
//  Created by daniel on 2024/12/27.
//

import os
import Foundation
import SocketIO
import Network

struct Message<T: Codable>: Codable {
    let messageId: String
    let messageType: String
    let data: T
    
    init(messageId: String = UUID().uuidString, messageType: String, data: T) {
        self.messageId = messageId
        self.messageType = messageType
        self.data = data
    }
}

public protocol IPCProtocol {
    associatedtype FromType: Codable
    associatedtype ToType: Codable
    static var messageType: String { get }
}

fileprivate let logger = Logger(subsystem: "com.socket_ipc", category: "client")

public struct ProjectToken: Codable, Sendable {
    public let type: String
    public let id: String

    init(type: String, id: String = UUID().uuidString) {
        self.type = type
        self.id = id
    }

    public static let extensionToken = ProjectToken(type: "extension")
    public static let inspectorToken = ProjectToken(type: "inspector")
}

enum SocketIPCClientError: Error {
    case unknow
    case timeout
}

public class SocketIPCClient {
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
    
    let projectToken: ProjectToken
    let url: URL
    let manager: SocketManager
    var socket: SocketIOClient

    public init(projectToken: ProjectToken, url: URL = URL(string: "http://localhost:56567")!) {
        self.projectToken = projectToken
        self.url = url

        manager = SocketManager(socketURL: url, config: [.log(true), .forceWebsockets(true)])
        manager.reconnects = true
        manager.reconnectWait = 1
        manager.reconnectWaitMax = 5

        socket = manager.defaultSocket

        setupIPCClient()
    }

    func setupIPCClient() {
        socket.on(clientEvent: .connect) { data, ack in
            ack.with("OK")
            logger.debug("IPC is connected!")
        }

        socket.on(clientEvent: .disconnect) { _, ack in
            ack.with("OK")
            logger.debug("IPC is disconnected!")
        }

        socket.on(clientEvent: .reconnectAttempt) { _, _ in
            logger.debug("IPC try to reconnect to server!")
        }

        socket.on(clientEvent: .error) { data, _ in
            logger.debug("IPC error: \(data)")
        }

        socket.on("whoareyou") { [weak self] _, ack in
            guard let self else { return }
            logger.debug("IPC who are you.")
            do {
                let data = try Self.jsonEncoder.encode(self.projectToken)
                ack.with(data)
            } catch {

            }
        }

        socket.on("ipc") { data, ack in
            logger.debug("IPC receive message: \(data)")
            ack.with("OK")

//            self.socket.emitWithAck("message", "world!").timingOut(after: 0) { data in
//                print("send message success")
//            }
        }

    }

    public func start() {
        logger.debug("Socket IPC start connect")
        // we will reconnect after 0.5s
        socket.connect(timeoutAfter: 0.5) {

        }
    }

    public func stop() {
        socket.disconnect()
    }
    
    private func request(_ data: Data, _ callback: @escaping (Data?, Error?) -> Void) {
        socket.emitWithAck("message", data).timingOut(after: 10) { datas in
            if datas.count == 1, let data = datas.first as? Data {
                callback(data, nil)
            } else {
                callback(nil, SocketIPCClientError.timeout)
            }
        }
    }
    
    private func request(_ message: Data) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            request(message) { data, error in
                if let data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: error ?? SocketIPCClientError.unknow)
                }
            }
        }
    }
    
    public func request<IPC: IPCProtocol>(_ protocolType: IPC.Type, data: IPC.FromType) async throws -> IPC.ToType {
        let messageType = protocolType.messageType
        let message = Message(messageType: messageType, data: data)
        let data = try Self.jsonEncoder.encode(message)
        let response = try await request(data)
        let responseMessage = try Self.jsonDecoder.decode(IPC.ToType.self, from: response)
        return responseMessage
    }
    
    public struct Request<IPC: IPCProtocol>: @unchecked Sendable {
        let message: IPC.FromType
        let response: (IPC.ToType) -> Void
//        @preconcurrency let ackEmitter: SocketAckEmitter
//        func response(_ message: IPC.ToType) {
//            
//        }
    }
    
    private func onMessage(data: Data) {
        
    }
    
    func on(_ messageType: String, _ callback: @escaping NormalCallback) {
        socket.on(messageType, callback: callback)
    }
    
    public func on<IPC: IPCProtocol>(_ protocolType: IPC.Type,
                                     _ callback: (Request<IPC>) -> Void) {
        let messageType = protocolType.messageType
        on(messageType) { datas, ack in
            
//            let request = Request(message: <#T##Decodable & Encodable#>, ackEmitter: <#T##SocketAckEmitter#>)
        }
    }
    
    public func on<IPC: IPCProtocol>(_ protocolType: IPC.Type) throws -> AsyncStream<Request<IPC>> {
        let messageType = protocolType.messageType
        return AsyncStream { continuation in
            self.on(messageType) { datas, ack in
                do {
                    if datas.count == 1, let data = datas.first as? Data {
                        let message = try Self.jsonDecoder.decode(IPC.FromType.self, from: data)
                        let request = Request<IPC>(message: message) { to in
                            do {
                                let data = try Self.jsonEncoder.encode(to)
                                ack.with(data)
                            } catch {
                                
                            }
                        }
                        continuation.yield(request)
                    }
                } catch {
                    
                }
            }
        }
    }
}
