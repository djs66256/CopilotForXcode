// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

extension SocketIPCClient {
    public static let shared: SocketIPCClient = {
        let url = URL(string: "http://localhost:56567")!
        return SocketIPCClient(projectToken: .inspectorToken, url: url)
    }()
}
