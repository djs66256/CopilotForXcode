//
//  Project+workspace.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/26.
//

import SocketIPC
import Workspace
import Service

extension Project {
    @MainActor var workspace: Workspace? {
        for (_, workspace) in Service.shared.workspacePool.workspaces {
            if (workspace.project == self) {
                return workspace
            }
        }
        return nil 
    }
}
