import ComposableArchitecture
import Dependencies
import Fundamental
import Storage
import SwiftUI

@Reducer
struct TabbyModelEdit {
    @ObservableState
    struct State: Equatable {
        var apiKeyName: String { apiKeySelection.apiKeyName }
        var url: String { urlSelection.baseURL }
        var apiKeySelection: APIKeySelection.State = .init()
        var urlSelection: BaseURLSelection.State = .init()
        var authorizationMode: TabbyModel.AuthorizationMode
        var authorizationHeaderName: String
        var username: String
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case appear
        case saveButtonClicked
        case readCustomModelFromDisk
        case apiKeySelection(APIKeySelection.Action)
        case urlSelection(BaseURLSelection.Action)
    }

    @Dependency(\.toast) var toast
    @Dependency(\.apiKeyKeychain) var keychain

    enum DebounceID: Hashable {
        case save
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.apiKeySelection, action: \.apiKeySelection) {
            APIKeySelection()
        }

        Scope(state: \.urlSelection, action: \.urlSelection) {
            BaseURLSelection()
        }

        Reduce { state, action in
            switch action {
            case .appear:
                return .run { send in
                    await send(.readCustomModelFromDisk)
                }

            case .saveButtonClicked:
                let model = TabbyModel(state: state)
                return .run { _ in
                    UserDefaults.shared.set(model, for: \.tabbyModel)
                }

            case .readCustomModelFromDisk:
                let model = UserDefaults.shared.value(for: \.tabbyModel)
                state = model.toState()
                return .none

            case .apiKeySelection:
                return .none

            case .urlSelection:
                return .none

            case .binding:
                return .none
            }
        }
    }

    func persistState(
        _: TabbyModelEdit.State,
        _ newValue: TabbyModelEdit.State
    ) -> some Reducer<State, Action> {
        Reduce { _, _ in
            .run { _ in
                let model = TabbyModel(state: newValue)
                UserDefaults.shared.set(model, for: \.tabbyModel)
            }
            .debounce(id: DebounceID.save, for: 1, scheduler: DispatchQueue.main)
        }
    }
}

extension TabbyModel {
    func toState() -> TabbyModelEdit.State {
        .init(
            apiKeySelection: .init(
                apiKeyName: apiKeyName,
                apiKeyManagement: .init(availableAPIKeyNames: [apiKeyName])
            ),
            urlSelection: .init(baseURL: url),
            authorizationMode: authorizationMode,
            authorizationHeaderName: authorizationHeaderName,
            username: username
        )
    }

    init(state: TabbyModelEdit.State) {
        self = .init(
            url: state.urlSelection.baseURL,
            authorizationMode: state.authorizationMode,
            apiKeyName: state.apiKeySelection.apiKeyName,
            authorizationHeaderName: state.authorizationHeaderName,
            username: state.username
        )
    }
}

