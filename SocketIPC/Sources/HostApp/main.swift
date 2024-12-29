//
//  main.swift
//  SocketIPC
//
//  Created by daniel on 2024/12/27.
//

import CoreFoundation
import Foundation
import stdio_h
import os
import SocketIPC
import ArgumentParser

fileprivate let logger = Logger(subsystem: "com.socket_ipc", category: "host_app")

logger.info("Socket IPC client host application.")

var client: SocketIPCClient?
//await Task {
    let url = URL(string: "http://localhost:56567")!
    logger.info("Socket IPC connect to \(url)")
    client = SocketIPCClient(url: url)
    client?.start()
//}.value


// wait
CFRunLoopRun()
