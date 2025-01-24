//
//  IPCProtocol.swift
//  SocketIPC
//
//  Created by daniel on 2025/1/13.
//

public struct Project: Codable, Sendable {
    public let id: String
    public let documentUrl: String
    public init(id: String, documentUrl: String) {
        self.id = id
        self.documentUrl = documentUrl
    }
}

public protocol IPCProtocol {
    associatedtype RequestType: Codable
    associatedtype ResponseType: Codable
    static var messageType: String { get }
}

public protocol FromCoreToXcodeIPCProtocol: IPCProtocol {

}

public protocol FromXcodeToCoreIPCProtocol: IPCProtocol {

}

extension IPCProtocol {
    public static func request(project: Project? = nil,
                               message: RequestType) async throws -> ResponseType {
        try await SocketIPCClient.shared.request(Self.self, project: project, message: message)
    }
}
