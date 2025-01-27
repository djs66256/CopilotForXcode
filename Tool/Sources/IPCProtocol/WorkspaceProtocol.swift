//
//  WorkspaceProtocol.swift
//  Tool
//
//  Created by daniel on 2025/1/27.
//

import SocketIPC

public struct ActiveWorkspace: FromXcodeToCoreIPCProtocol {
    public typealias RequestType = Project
    public typealias ResponseType = Void
    
    public static var messageType: String { "ide/activeWorkspace" }
}

public struct DeactiveWorkspace: FromXcodeToCoreIPCProtocol {
    public typealias RequestType = Project
    public typealias ResponseType = Void
    
    public static var messageType: String { "ide/deactiveWorkspace" }
}


