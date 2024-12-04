import ComposableArchitecture
import Foundation
import Storage
import SwiftUI

@Reducer
struct BaseURLSelection {
    @ObservableState
    struct State: Equatable {
        var baseURL: String = ""
        var isFullURL: Bool = false
        var availableBaseURLs: [String] = []
    }

    enum Action: Equatable, BindableAction {
        case appear
        case refreshAvailableBaseURLNames
        case binding(BindingAction<State>)
    }

    @Dependency(\.toast) var toast
    @Dependency(\.userDefaults) var userDefaults

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .appear:
                return .run { send in
                    await send(.refreshAvailableBaseURLNames)
                }

            case .refreshAvailableBaseURLNames:
                let chatModels = userDefaults.value(for: \.chatModelsFromCopilotForXcode)
                var allBaseURLs = Set(
                    chatModels.map(\.info.baseURL)
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                )
                allBaseURLs.remove("")
                state.availableBaseURLs = Array(allBaseURLs).sorted()
                return .none

            case .binding:
                return .none
            }
        }
    }
}

