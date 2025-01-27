//
//  Untitled.swift
//  SocketIPC
//
//  Created by daniel on 2025/1/13.
//

import SocketIPC

public struct GetIdeInfo: FromCoreToXcodeIPCProtocol {
    public typealias RequestType = Void
    
    public struct Response: Codable, Sendable {
        public var ideType: String = "xcode"
        public var name: String = "xcode"
        public let version: String
        public let remoteName: String
        public let extensionVersion: String
    }
    public typealias ResponseType = Response
    
    public static var messageType: String { "ide/getIdeInfo" }
}

public struct GetWorkspaces: FromCoreToXcodeIPCProtocol {
    public typealias RequestType = Void

    public struct Response: Codable, Sendable {
        public let dir: String

        public init(dir: String) {
            self.dir = dir
        }
    }
    public typealias ResponseType = [Response]
    
    public static var messageType: String { "ide/getWorkspaces" }
}

public struct GetOpenFiles: FromCoreToXcodeIPCProtocol {
    public typealias RequestType = Void
    
    public typealias ResponseType = [String]
    
    public static var messageType: String { "ide/getOpenFiles"}
    
    
}
/*
public struct GetCurrentFile: FromCoreToXcodeIPCProtocol {
    
}

public struct ReadFile: FromCoreToXcodeIPCProtocol {
    
}

public struct WriteFile: FromCoreToXcodeIPCProtocol {
    
}

public struct GetProblems: FromCoreToXcodeIPCProtocol {
    
}
*/
