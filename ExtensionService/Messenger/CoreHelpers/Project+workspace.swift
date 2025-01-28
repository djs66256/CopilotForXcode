//
//  Project+workspace.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/26.
//

import SocketIPC
import Workspace
import Service
import XcodeInspector

extension Project {
    @MainActor var workspace: Workspace? {
        for (_, workspace) in Service.shared.workspacePool.workspaces {
            if (workspace.project == self) {
                return workspace
            }
        }
        return nil
    }

    var xcode: XcodeAppInstanceInspector? {
        for xcode in XcodeInspector.shared.xcodes {
            if xcode.projectRootURL?.absoluteString == self.documentUrl {
                return xcode
            }
        }
        return nil
    }
}
