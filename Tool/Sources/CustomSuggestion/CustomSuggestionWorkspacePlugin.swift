import Foundation
import Logger
import Workspace

public final class CustomSuggestionWorkspacePlugin: WorkspacePlugin {
    private var _customService: CustomService?
    @CustomSuggestionActor
    var customSuggestionService: CustomService? {
        if let service = _customService { return service }
        do {
            return try createCodeiumService()
        } catch {
            Logger.customSuggestion.error("Failed to create CustomSuggestion service: \(error)")
            return nil
        }
    }

    deinit {
        if let _customService {
//            _customService.terminate()
        }
    }

    @CustomSuggestionActor
    func createCodeiumService() throws -> CustomService {
        let newService = CustomService()
        _customService = newService
        return newService
    }

    @CustomSuggestionActor
    func finishLaunchingService() {
        guard let workspace, let _customService else { return }
        Task {
//            try? await _customService.notifyOpenWorkspace(workspaceURL: workspaceURL)
//
//            for (_, filespace) in workspace.filespaces {
//                let documentURL = filespace.fileURL
//                guard let content = try? String(contentsOf: documentURL) else { continue }
//                try? await _customService.notifyOpenTextDocument(
//                    fileURL: documentURL,
//                    content: content
//                )
//            }
        }
    }

    func terminate() {
        _customService = nil
    }
}

