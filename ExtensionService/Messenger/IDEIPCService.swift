//
//  IDEIPCService.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/24.
//

import SocketIPC

class IDEIPCService {
    let server: SocketIPCClient
    init(server: SocketIPCClient) {
        self.server = server 

        GetOpenFiles.onProject { project, request in
            if let workspace = await project.workspace {
                let urls = workspace.openedFileRecoverableStorage.openedFiles
                return urls.map {
                    $0.path(percentEncoded: false)
                }
            }
            throw SocketIPCClientError.serverError(code: -1, error: "")
        }
    }
    
}
