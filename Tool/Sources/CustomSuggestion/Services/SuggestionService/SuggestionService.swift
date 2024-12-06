import CopilotForXcodeKit
import Foundation
//import Fundamental

public class SuggestionService: SuggestionServiceType {
    let service = Service()

    public init() {}

    public func terminate() {
        
    }

    public var configuration: SuggestionServiceConfiguration {
        .init(
            acceptsRelevantCodeSnippets: true,
            mixRelevantCodeSnippetsInSource: false,
            acceptsRelevantSnippetsFromOpenedFiles: true
        )
    }

    public func notifyAccepted(_ suggestion: CodeSuggestion, workspace: WorkspaceInfo) async {}

    public func notifyRejected(_ suggestions: [CodeSuggestion], workspace: WorkspaceInfo) async {}

    public func cancelRequest(workspace: WorkspaceInfo) async {
        await service.cancelRequest()
    }

    public func getSuggestions(
        _ request: SuggestionRequest,
        workspace: WorkspaceInfo
    ) async throws -> [CodeSuggestion] {
        try await service.getSuggestions(request, workspace: workspace)
    }

    public func notifyAccepted(_ suggestion: CodeSuggestion) async {
//        _ = try? await (try setupServerIfNeeded())
//            .sendRequest(CodeiumRequest.AcceptCompletion(requestBody: .init(
//                metadata: getMetadata(),
//                completion_id: suggestion.id
//            )))
    }

    public func notifyOpenTextDocument(fileURL: URL, content: String) async throws {
//        let relativePath = getRelativePath(of: fileURL)
//        await openedDocumentPool.openDocument(
//            url: fileURL,
//            relativePath: relativePath,
//            content: content
//        )
    }

    public func notifyChangeTextDocument(fileURL: URL, content: String) async throws {
//        let relativePath = getRelativePath(of: fileURL)
//        await openedDocumentPool.updateDocument(
//            url: fileURL,
//            relativePath: relativePath,
//            content: content
//        )
    }

    public func notifyCloseTextDocument(fileURL: URL) async throws {
//        await openedDocumentPool.closeDocument(url: fileURL)
    }

    public func notifyOpenWorkspace(workspaceURL: URL) async throws {
//        _ = try await (setupServerIfNeeded()).sendRequest(
//            CodeiumRequest
//                .AddTrackedWorkspace(requestBody: .init(workspace: workspaceURL.path))
//        )
    }

    public func notifyCloseWorkspace(workspaceURL: URL) async throws {
//        _ = try await (setupServerIfNeeded()).sendRequest(
//            CodeiumRequest
//                .RemoveTrackedWorkspace(requestBody: .init(workspace: workspaceURL.path))
//        )
    }
}

