import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var keychain: Keychain
    @State private var showKey = false
    @State private var showingCreate = false

    var body: some View {
        Form {
            Section {
                if keychain.keys.isEmpty {
                    Text("No keys present.")
                        .font(.footnote)
                }
                ForEach(Array(keychain.keys), id: \.name) { key in
                    Button(key.name) {
                        showKey = true
                    }
                    .sheet(isPresented: $showKey) {
                        KeyView(key: key)
                        .padding()
                        .presentationDetents([.medium, .large])
                    }
                }
                Button("Create new key") {
                    showingCreate.toggle()
                }
                .sheet(isPresented: $showingCreate) {
                    CreateKeyView()
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
            .environmentObject(Keychain())
    }
}
