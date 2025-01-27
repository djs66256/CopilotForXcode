//
//  IDEIPCService.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/24.
//

import SocketIPC
import IPCProtocol
import Service

class IDEIPCService {
    let server: SocketIPCClient
    init(server: SocketIPCClient) {
        self.server = server 

        GetOpenFiles.on { task in
            if let project = task.project, let workspace = await project.workspace {
                let urls = workspace.openedFileRecoverableStorage.openedFiles
                // remove duplicated
                return urls.map {
                    $0.absoluteString
                }
            }
            throw SocketIPCClientError.serverError(code: -1, error: "")
        }

        GetWorkspaces.on { task in
            return await Task { @MainActor in
                return Service.shared.workspacePool.workspaces.map{ (key, workspace) in
                    GetWorkspaces.Response(
                        dir: workspace.projectRootURL.path(percentEncoded: false)
                    )
                }
            }.value
        }
    }
    
}
