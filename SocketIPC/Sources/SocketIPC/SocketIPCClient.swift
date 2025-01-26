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

public enum SocketIPCClientError: Error {
    case unknow
    case timeout
    case serverError(code: Int, error: String)
    case clientError(code: Int, error: String)
}

fileprivate let jsonEncoder = JSONEncoder()
fileprivate let jsonDecoder = JSONDecoder()

public class SocketIPCClient: @unchecked Sendable {

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
                let data = try jsonEncoder.encode(self.projectToken)
                ack.with(data)
            } catch {

            }
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

    private func requestSocket(_ messageType: String, data: Data, _ callback: @escaping (Data?, Error?) -> Void) {
        let event = "xcode:\(messageType)"
        socket.emitWithAck(event, data).timingOut(after: 10) { datas in
            if datas.count == 1, let data = datas.first as? Data {
                callback(data, nil)
            } else {
                callback(nil, SocketIPCClientError.timeout)
            }
        }
    }

    private func requestData(_ messageType: String, data: Data) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            requestSocket(messageType, data: data) { data, error in
                if let data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: error ?? SocketIPCClientError.unknow)
                }
            }
        }
    }

    enum ResponseCode: Int {
        case ok = 0
    }

    struct Response<T: Codable>: Codable {
        let code: Int
        let error: String?
        let data: T?
    }

    struct ResponseVoid: Codable {
        let code: Int
        let error: String?
    }

    struct ProjectRequest<T: Codable>: Codable {
        let project: Project?
        let message: T
    }

    struct ProjectRequestVoid: Codable {
        let project: Project?
    }

    public func request<IPC: IPCProtocol>(
        _ protocolType: IPC.Type,
        project: Project? = nil,
        message: IPC.RequestType) async throws -> IPC.ResponseType
    where IPC.RequestType: Codable, IPC.ResponseType: Codable {
        let request = ProjectRequest(project: project, message: message)
        let requestData = try jsonEncoder.encode(request)
        let responseData = try await self.requestData(protocolType.messageType, data: requestData)
        let response = try jsonDecoder.decode(Response<IPC.ResponseType>.self, from: responseData)
        if response.code == ResponseCode.ok.rawValue, let res = response.data {
            return res
        } else {
            throw SocketIPCClientError.serverError(code: response.code, error: response.error ?? "unknow")
        }
    }

    public func request<IPC: IPCProtocol>(
        _ protocolType: IPC.Type,
        project: Project? = nil,
        message: IPC.RequestType) async throws -> IPC.ResponseType
    where IPC.RequestType == Void, IPC.ResponseType: Codable {
        let request = ProjectRequestVoid(project: project)
        let requestData = try jsonEncoder.encode(request)
        let responseData = try await self.requestData(protocolType.messageType, data: requestData)
        let response = try jsonDecoder.decode(Response<IPC.ResponseType>.self, from: responseData)
        if response.code == ResponseCode.ok.rawValue, let res = response.data {
            return res
        } else {
            throw SocketIPCClientError.serverError(code: response.code, error: response.error ?? "unknow")
        }
    }

    private func onSocket(_ messageType: String, _ callback: @escaping NormalCallback) {
        let event = "xcode:\(messageType)"
        socket.on(event, callback: callback)
    }

    private func onData(
        _ messageType: String,
        _ callback: @escaping @Sendable (_ data: Data, _ callback: @escaping @Sendable (Result<Data, Error>) -> Void) -> Void
    ) {
        onSocket(messageType) { datas, ack in
            @Sendable func responseData(_ response: Data) {
                ack.with(response)
            }

            func responseError(code: Int, error: String) {
                let response = Response<String>(code: -1, error: "", data: nil)
                let data = try? jsonEncoder.encode(response)
                ack.with(data ?? "")
            }

            func responseError(_ error: Error) {
                if let error = error as? SocketIPCClientError {
                    switch error {
                    case .unknow:
                        responseError(code: -1, error: "unknow")
                    case .timeout:
                        responseError(code: -999, error: "timeout")
                    case .serverError(let code, let error):
                        responseError(code: code, error: error)
                    case .clientError(let code, let error):
                        responseError(code: code, error: error)
                    }
                } else {
                    responseError(code: -1, error: error.localizedDescription)
                }
            }

            if let data = datas.first as? Data {
                callback(data) { result in
                    switch result {
                    case .success(let success):
                        responseData(success)
                    case .failure(let failure):
                        responseError(failure)
                    }
                }
            }
        }
    }

//    public struct IPCTask<IPC: IPCProtocol>: @unchecked Sendable {
//        public let project: Project?
//        public let request: IPC.RequestType
//        public let response: (Result<IPC.ResponseType, Error>) -> Void
//
//        init(
//            project: Project?,
//            request: IPC.RequestType,
//            response: @escaping (Result<Data, Error>) -> Void
//        ) where IPC.ResponseType: Codable {
//            self.project = project
//            self.request = request
//            self.response = { result in
//                switch result {
//                case .success(let data):
//                    let responseWrapper = Response(code: 0, error: nil, data: data)
//                    do {
//                        let data = try jsonEncoder.encode(responseWrapper)
//                        response(.success(data))
//                    } catch {
//                        response(.failure(error))
//                    }
//                case .failure(let error):
//                    response(.failure(error))
//                }
//            }
//        }
//    }
//
//    public func on<IPC: IPCProtocol>(
//        _ protocolType: IPC.Type,
//        _ callback: @escaping (IPCTask<IPC>) throws -> Void)
//    where IPC.RequestType: Codable, IPC.ResponseType: Codable {
//        onData(protocolType.messageType) { data, cb in
//            do {
//                let request = try jsonDecoder.decode(ProjectRequest<IPC.RequestType>.self, from: data)
//                let task = IPCTask<IPC>(project: request.project, request: request.message, response: cb)
//                try callback(task)
//            } catch {
//                cb(.failure(error))
//            }
//        }
//    }
//
//    public func on<IPC: IPCProtocol>(_ protocolType: IPC.Type,
//                                     _ callback: @escaping (IPCTask<IPC>) throws -> Void)
//    where IPC.RequestType == Void, IPC.ResponseType: Codable {
//        onData(protocolType.messageType) { data, cb in
//            do {
//                let request = try jsonDecoder.decode(ProjectRequestVoid.self, from: data)
//                let task = IPCTask<IPC>(project: request.project, request: (), response: cb)
//                try callback(task)
//            } catch {
//                cb(.failure(error))
//            }
//        }
//    }

    public struct IPCRequest<RequestType>: @unchecked Sendable {
        public let project: Project?
        public let request: RequestType
    }

    public func on<IPC: IPCProtocol>(
        _ protocolType: IPC.Type,
        _ callback: @escaping @Sendable (_ task: IPCRequest<IPC.RequestType>) async throws -> IPC.ResponseType)
    where IPC.RequestType: Codable, IPC.ResponseType: Codable {
        onData(protocolType.messageType) { data, cb in
            Task {
                do {
                    let request = try jsonDecoder.decode(ProjectRequest<IPC.RequestType>.self, from: data)
                    let task = IPCRequest(project: request.project, request: request.message)
//                    let response = try await callback(task)
//                    let responseData = try jsonEncoder.encode(response)
//                    cb(.success(responseData))
                } catch {
//                    cb(.failure(error))
                }
            }
        }
    }

    public func on<IPC: IPCProtocol>(
        _ protocolType: IPC.Type,
        _ callback: @escaping @Sendable (_ task: IPCRequest<Void>) async throws -> IPC.ResponseType)
    where IPC.RequestType == Void, IPC.ResponseType: Codable {
        onData(protocolType.messageType) { data, cb in
            Task {
                do {
                    let request = try jsonDecoder.decode(ProjectRequestVoid.self, from: data)
                    let task = IPCRequest(project: request.project, request: ())
                    let response = try await callback(task)
                    let responseData = try jsonEncoder.encode(response)
                    cb(.success(responseData))
                } catch {
                    cb(.failure(error))
                }
            }
        }
    }

//    public func on<IPC: IPCProtocol>(_ protocolType: IPC.Type) -> AsyncStream<Request<IPC>> {
//        let messageType = protocolType.messageType
//        return AsyncStream { continuation in
//            Task {
//                await withTaskCancellationHandler {
//                    self.on(messageType) { datas, ack in
//                        do {
//                            if datas.count == 1, let data = datas.first as? Data {
//                                let message = try Self.jsonDecoder.decode(IPC.RequestType.self, from: data)
//                                
//                                if Task.isCancelled { return }
//                                let request = Request<IPC>(message: message) { to in
//                                    do {
//                                        let data = try Self.jsonEncoder.encode(to)
//                                        ack.with(data)
//                                    } catch {
//                                        
//                                    }
//                                }
//                                continuation.yield(request)
//                            }
//                        } catch {
//                            
//                        }
//                    }
//                } onCancel: {
//                    self.off(protocolType)
//                }
//            }
//        }
//    }

    @preconcurrency
    public func off<IPC: IPCProtocol>(_ protocolType: IPC.Type) {
        socket.off(protocolType.messageType)
    }
}
