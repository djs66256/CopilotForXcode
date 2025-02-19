//
//  Project+workspace.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/26.
//

import SocketIPC
import Workspace
import Service
import XcodeInspector

extension Project {
    @MainActor var workspace: Workspace? {
        for (_, workspace) in Service.shared.workspacePool.workspaces {
            if (workspace.project == self) {
                return workspace
            }
        }
        return nil
    }

    var xcode: XcodeAppInstanceInspector? {
        for xcode in XcodeInspector.shared.xcodes {
            if xcode.projectRootURL?.absoluteString == self.documentUrl {
                return xcode
            }
        }
        return nil
    }

    func createSourceEditor() -> SourceEditor? {
        guard let xcode = self.xcode else { return nil }
        let focusedElement = xcode.appElement.focusedElement
        if let editorElement = focusedElement, editorElement.isSourceEditor {
            return .init(
                runningApplication: xcode.runningApplication,
                element: editorElement
            )
        } else if let element = focusedElement,
                  let editorElement = element.firstParent(where: \.isSourceEditor)
        {
            return .init(
                runningApplication: xcode.runningApplication,
                element: editorElement
            )
        } else {
            return nil
        }
    }
}
