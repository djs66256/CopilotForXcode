import ComposableArchitecture
import SwiftUI

struct APIKeyPicker: View {
    @Perception.Bindable var store: StoreOf<APIKeySelection>
    var title: String = "API Key"

    var body: some View {
        WithPerceptionTracking {
            HStack {
                Picker(
                    selection: $store.apiKeyName,
                    content: {
                        Text("No API Key").tag("")
                        if store.availableAPIKeyNames.isEmpty {
                            Text("No API key found, please add a new one →")
                        }
                        
                        if !store.availableAPIKeyNames.contains(store.apiKeyName),
                           !store.apiKeyName.isEmpty {
                            Text("Key not found: \(store.state.apiKeyName)")
                                .tag(store.apiKeyName)
                        }
                        
                        ForEach(store.availableAPIKeyNames, id: \.self) { name in
                            Text(name).tag(name)
                        }
                        
                    },
                    label: { Text(title) }
                )
                
                Button(action: { store.send(.manageAPIKeysButtonClicked) }) {
                    Text(Image(systemName: "key"))
                }
            }.sheet(isPresented: $store.isAPIKeyManagementPresented) {
                APIKeyManagementView(store: store.scope(
                    state: \.apiKeyManagement,
                    action: \.apiKeyManagement
                ))
            }
            .onAppear {
                store.send(.appear)
            }
        }
    }
}

