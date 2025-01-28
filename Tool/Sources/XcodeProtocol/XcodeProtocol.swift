//
//  XcodeProtocol.swift
//  Tool
//
//  Created by daniel on 2025/1/28.
//



public protocol XcodeMessageProtocol {
    public associatedtype RequestType
    public associatedtype ResponseType
    public static var message: String { get }
}

public protocol XcodeExtensionToInspectorProtocol: XcodeMessageProtocol {

}

public protocol XcodeInspectorToExtensionProtocol: XcodeMessageProtocol {

}

public class XcodeExtensionMessageChannel {

    public func request<T: XcodeExtensionToInspectorProtocol>() {

    }

    public class Task {

    }

    public func on<T: XcodeInspectorToExtensionProtocol>() {

    }
}
