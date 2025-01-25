//
//  FromXcodeToCoreIPCProtocol.swift
//  SocketIPC
//
//  Created by daniel on 2025/1/13.
//

import Foundation
import SuggestionBasic
@preconcurrency import XPCShared

public struct RangeInFileWithContents: Codable, Sendable {
    public let filepath: String
    public let range: Range
    public let contents: String
    public init(filepath: String, range: Range, contents: String) {
        self.filepath = filepath
        self.range = range
        self.contents = contents
    }
}

public struct RecentlyEditedRange: Codable, Sendable {
    public let timestamp: Double
    public let lines: [String]
    public let symbols: Set<String>
    public init(timestamp: Double, lines: [String], symbols: Set<String>) {
        self.timestamp = timestamp
        self.lines = lines
        self.symbols = symbols
    }
}

public struct SelectedCompletionInfo: Codable, Sendable {
    public let text: String
    public let range: Range
    public init(text: String, range: Range) {
        self.text = text
        self.range = range
    }
}

public struct GetSuggestion: FromXcodeToCoreIPCProtocol {
    public static var messageType: String { "autocomplete/getSuggestion" }

    public struct Request: Codable, Sendable {
        public let document: EditorContent
        public let isUntitledFile: Bool
        public let completionId: String
        public let filepath: String
        public let pos: Position
        public let recentlyEditedFiles: [RangeInFileWithContents]
        public let recentlyEditedRanges: [RecentlyEditedRange]
        public let manuallyPassFileContents: String?
        public let selectedCompletionInfo: SelectedCompletionInfo?
        public let injectDetails: String?

        public init(
            document: EditorContent,
            isUntitledFile: Bool,
            completionId: String,
            filepath: String,
            pos: Position,
            recentlyEditedFiles: [RangeInFileWithContents],
            recentlyEditedRanges: [RecentlyEditedRange],
            manuallyPassFileContents: String?,
            selectedCompletionInfo: SelectedCompletionInfo?,
            injectDetails: String?
        ) {
            self.document = document
            self.isUntitledFile = isUntitledFile
            self.completionId = completionId
            self.filepath = filepath
            self.pos = pos
            self.recentlyEditedFiles = recentlyEditedFiles
            self.recentlyEditedRanges = recentlyEditedRanges
            self.manuallyPassFileContents = manuallyPassFileContents
            self.selectedCompletionInfo = selectedCompletionInfo
            self.injectDetails = injectDetails
        }
    }

    public typealias RequestType = Request
    public typealias ResponseType = [CodeSuggestion]
}

public struct AcceptSuggestion: FromXcodeToCoreIPCProtocol {
    public static var messageType: String { "autocomplete/accept" }

    public struct Request: Codable, Sendable {
        public let completionId: String

        public init(completionId: String) {
            self.completionId = completionId
        }
    }

    public struct Response: Codable, Sendable { }

    public typealias RequestType = Request
    public typealias ResponseType = Response
}

