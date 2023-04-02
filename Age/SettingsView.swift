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
    @State private var keys: [Key] = []
    @State private var showingCreate = false

    var body: some View {
        List {
            Section("Keys") {
                if keys.isEmpty {
                    Text("No keys present.")
                        .font(.footnote)
                }
                ForEach(Array(keys), id: \.self) { key in
                    Text(key.name)
                }
                Button("Create new key") {
                    showingCreate.toggle()
                }
                .sheet(isPresented: $showingCreate) {
                    CreateKeyView(keys: $keys)
                }
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
