import SwiftUI

struct KeyView: View {
    @EnvironmentObject var keychain: Keychain
    @Environment(\.dismiss) var dismiss
    var key: Key

    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack {
            Text(key.name)
                .font(.headline)
                .padding()
            Text("Public Key")
                .font(.subheadline)
                .padding(.top)
            Text(key.key)
                .font(.system(size: 12, design: .monospaced))
                .textSelection(.enabled)
                .padding()
            Spacer()
            Button("Delete", role: .destructive) {
                showDeleteConfirmation = true
            }
            .confirmationDialog("Are you sure?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    keychain.delete(name: key.name)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Deleting the key is permanent and cannot be recovered.")
            }
        }
    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView(key: Key(name: "Test", key: "age1testtesttesttesttesttesttesttesttesttesttesttesttesttesttest", createdDate: Date.now))
            .environmentObject(Keychain())
    }
}
