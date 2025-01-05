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

public class SocketIPCClient {
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
            let encoder = JSONEncoder()
            let data = encoder.encode(self.projectToken)
            ack.with(data)
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
}
