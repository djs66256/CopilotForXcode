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
public struct GetCurrentFile: FromCoreToXcodeIPCProtocol {
    public typealias RequestType = Void
    public struct Response: Codable, Sendable {
        public let isUntitled: Bool
        public let path: String
        public let contents: String
        public init(isUntitled: Bool, path: String, contents: String) {
            self.isUntitled = isUntitled
            self.path = path
            self.contents = contents
        }
    }
    public typealias ResponseType = Response
    public static var messageType: String { "ide/getCurrentFile" }
}

public struct ReadFile: FromCoreToXcodeIPCProtocol {
    public struct Request: Codable, Sendable {
        public let fileUrl: String
        public let range: Range?
        public init(fileUrl: String, range: Range?) {
            self.fileUrl = fileUrl
            self.range = range
        }
    }
    public typealias RequestType = Request

    public struct Response: Codable, Sendable {
        public let content: String
        public init(content: String) {
            self.content = content
        }
    }
    public typealias ResponseType = Response
    public static var messageType: String { "ide/readFile" }
}

public struct WriteFile: FromCoreToXcodeIPCProtocol {
    public struct Request: Codable, Sendable {
        public let fileUrl: String
        public let content: String
        public init(fileUrl: String, content: String) {
            self.fileUrl = fileUrl
            self.content = content
        }
    }
    public typealias RequestType = Request

    public struct Response: Codable, Sendable {
        public let success: Bool
        public init(success: Bool) {
            self.success = success
        }
    }
    public typealias ResponseType = Response
    public static var messageType: String { "ide/writeFile" }
}

/*
public struct GetProblems: FromCoreToXcodeIPCProtocol {

}
*/
