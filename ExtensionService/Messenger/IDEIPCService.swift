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
        
        server.on(GetOpenFiles.self) { request in
            request.
        }
    }
    
}
