import Foundation
import Logger
import Workspace

public final class CustomSuggestionWorkspacePlugin: WorkspacePlugin {
    private var _customSuggestionService: SuggestionService?
    @CustomSuggestionActor
    var customSuggestionService: SuggestionService? {
        if let service = _customSuggestionService { return service }
        do {
            return try createCodeiumService()
        } catch {
            Logger.customSuggestion.error("Failed to create CustomSuggestion service: \(error)")
            return nil
        }
    }

    deinit {
        if let _customSuggestionService {
            _customSuggestionService.terminate()
        }
    }

    @CustomSuggestionActor
    func createCodeiumService() throws -> SuggestionService {
        let newService = SuggestionService()
        _customSuggestionService = newService
        return newService
    }

    @CustomSuggestionActor
    func finishLaunchingService() {
        guard let workspace, let _customSuggestionService else { return }
        Task {
            try? await _customSuggestionService.notifyOpenWorkspace(workspaceURL: workspaceURL)

            for (_, filespace) in workspace.filespaces {
                let documentURL = filespace.fileURL
                guard let content = try? String(contentsOf: documentURL) else { continue }
                try? await _customSuggestionService.notifyOpenTextDocument(
                    fileURL: documentURL,
                    content: content
                )
            }
        }
    }

    func terminate() {
        _customSuggestionService = nil
    }
}

