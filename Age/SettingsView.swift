import SwiftUI

struct Key: Codable, Hashable {
    /// A human-readable name for the key.
    var name: String
    /// The Bech32-encoded secret key.
    var key: String
    var createdDate: Date
}

extension Key: Comparable {
    static func < (lhs: Key, rhs: Key) -> Bool {
        lhs.name < rhs.name
    }
}

struct SettingsView: View {
    @State private var showKey = false
    @State private var keys: [Key] = Keychain.getKeys()
    @State private var showingCreate = false

    var body: some View {
        Form {
            Section {
                if keys.isEmpty {
                    Text("No keys present.")
                        .font(.footnote)
                }
                ForEach(Array(keys), id: \.self) { key in
                    Button(key.name) {
                        showKey = true
                    }
                    .alert(isPresented: $showKey) {
                        Alert(title: Text("Public Key"), message: Text(key.key))
                    }
                }
                Button("Create new key") {
                    showingCreate.toggle()
                }
                .sheet(isPresented: $showingCreate) {
                    CreateKeyView(keys: $keys)
                }
            } header: {
                Text("Keys")
            } footer: {
                Text("A key pair is needed if you want to share a secret with more than one person or by not using a shared password.")
            }

            Section {
                Button("About") {}
            }

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
