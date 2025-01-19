//
//  IPCMessenger.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/19.
//

import SocketIPC
import XcodeInspector

class IPCMessenger {
    static let shared = IPCMessenger()

    func setup() {
        if let workspaces = XcodeInspector.shared.activeXcode?.workspaces {
            for (id, workspace) in workspaces {
                let element = workspace.element
                let info = workspace.info
                print("\(element)")
                print("\(info)")
            }
        }
    }
}
