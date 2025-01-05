//
//  SocketIPCClient+shared.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/5.
//

import Foundation
import SocketIPC

extension SocketIPCClient {
    static let shared: SocketIPCClient = {
        let url = URL(string: "http://localhost:56567")!
        return SocketIPCClient(projectToken: .inspectorToken, url: url)
    }()
}
