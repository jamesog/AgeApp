import SwiftUI
import AgeKit

struct CreateKeyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var generatedIdentity: Age.X25519Identity?
    @Binding var keys: [Key]

    private var names: [String] {
        keys.map { $0.name }
    }

    private var generateDisbled: Bool {
        name.isEmpty || names.contains(name)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .autocorrectionDisabled()
                    if names.contains(name) {
                        Label("Name already exists", systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                    }
                }

                if let id = generatedIdentity {
                    Section("Public key") {
                        Text(id.recipient.string)
                            .font(.system(size: 12, design: .monospaced))
                            .textSelection(.enabled)
                    }

                    Section("Private key") {
                        Text(id.string)
                            .font(.system(size: 12, design: .monospaced))
                            .privacySensitive()
                            .textSelection(.enabled)
                    }
                }

                Section {
                    Button("Generate key") {
                        generatedIdentity = Age.X25519Identity.generate()
                        Keychain.save(name: name, publicKey: generatedIdentity!.recipient.string, privateKey: generatedIdentity!.string)
                        keys = Keychain.getKeys()
                        name = ""
                    }
                    .disabled(generateDisbled)
                }
            }
            .navigationBarTitle("Create key", displayMode: .inline)
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CreateKeyView_Previews: PreviewProvider {
    static var previews: some View {
        @State var identities: [Key] = []
        CreateKeyView(keys: $identities)
    }
}
