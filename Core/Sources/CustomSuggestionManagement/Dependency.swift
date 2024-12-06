import CopilotForXcodeKit
import Dependencies
//import SuggestionService
import CustomSuggestion

// MARK: - SuggestionService

struct SuggestionServiceDependencyKey: DependencyKey {
    static var liveValue: CopilotForXcodeKit.SuggestionServiceType = SingleWorkspceSuggestionService()
    static var previewValue: CopilotForXcodeKit.SuggestionServiceType = MockSuggestionService()
}

struct SingleWorkspceSuggestionService: CopilotForXcodeKit.SuggestionServiceType {
    var configuration: SuggestionServiceConfiguration {
        .init(
            acceptsRelevantCodeSnippets: true,
            mixRelevantCodeSnippetsInSource: false,
            acceptsRelevantSnippetsFromOpenedFiles: true
        )
    }

    let service = CustomService()

    func getSuggestions(
        _ request: SuggestionRequest,
        workspace: WorkspaceInfo
    ) async throws -> [CodeSuggestion] {
        try await service.getSuggestions(request, workspace: workspace)
    }

    func notifyAccepted(_: CodeSuggestion, workspace: WorkspaceInfo) async {
        print("Accepted")
    }

    func notifyRejected(_: [CodeSuggestion], workspace: WorkspaceInfo) async {
        print("Rejected")
    }

    func cancelRequest(workspace: WorkspaceInfo) async {
        print("Cancelled")
    }
}

struct MockSuggestionService: CopilotForXcodeKit.SuggestionServiceType {
    var configuration: SuggestionServiceConfiguration {
        .init(
            acceptsRelevantCodeSnippets: true,
            mixRelevantCodeSnippetsInSource: false,
            acceptsRelevantSnippetsFromOpenedFiles: true
        )
    }

    func getSuggestions(
        _: SuggestionRequest,
        workspace: WorkspaceInfo
    ) async throws -> [CodeSuggestion] {
        [.init(id: "id", text: "Hello World", position: .zero, range: .zero)]
    }

    func notifyAccepted(_: CodeSuggestion, workspace: WorkspaceInfo) async {
        print("Accepted")
    }

    func notifyRejected(_: [CodeSuggestion], workspace: WorkspaceInfo) async {
        print("Rejected")
    }

    func cancelRequest(workspace: WorkspaceInfo) async {
        print("Cancelled")
    }
}

extension DependencyValues {
    var suggestionService: CopilotForXcodeKit.SuggestionServiceType {
        get { self[SuggestionServiceDependencyKey.self] }
        set { self[SuggestionServiceDependencyKey.self] = newValue }
    }
}

