import CopilotForXcodeKit
import Dependencies
//import SuggestionService
import CustomSuggestion

// MARK: - SuggestionService

struct SuggestionServiceDependencyKey: DependencyKey {
    static var liveValue: CopilotForXcodeKit.SuggestionServiceType = SuggestionService()
    static var previewValue: CopilotForXcodeKit.SuggestionServiceType = MockSuggestionService()
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

