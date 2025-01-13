//
//  FromXcodeToCoreIPCProtocol.swift
//  SocketIPC
//
//  Created by daniel on 2025/1/13.
//

struct GetSuggestion: FromXcodeToCoreIPCProtocol {
    static var messageType: String { "xcode/autocomplete/getSuggestion" }

    struct Request: Codable {

    }

    struct Response: Codable {

    }

    typealias RequestType = Request
    typealias ResponseType = Response
}

struct AcceptSuggestion {
    static var messageType: String { "xcode/autocomplete/acceptSuggestion" }

    struct Request: Codable {

    }

    struct Response: Codable {

    }

    typealias RequestType = Request
    typealias ResponseType = Response
}

struct RejectSuggestion {
    static var messageType: String { "xcode/autocomplete/rejectSuggestion" }

    struct Request: Codable {

    }

    struct Response: Codable {

    }

    typealias RequestType = Request
    typealias ResponseType = Response
}
