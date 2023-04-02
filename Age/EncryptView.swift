import SwiftUI
import AgeKit

struct EncryptView: View {
    @State private var plaintext = ""
    @State private var method = Method.scrypt

    @State private var password = ""
    @State private var recipients: [String] = []
    @FocusState private var recipientFocused: Bool

    @State private var encrypting = false
    @State private var ciphertext = ""
    @State private var copied = false

    private let pasteboard = UIPasteboard.general

    private var disableButton: Bool {
        switch method {
        case .scrypt:
            return password.isEmpty || plaintext.isEmpty
        case .x25519:
            return recipients.isEmpty || plaintext.isEmpty
        }
    }

    var body: some View {
        Form {
            Section {
                Picker("Encryption method", selection: $method.animation()) {
                    ForEach(Method.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                switch method {
                case .scrypt :
                    SecureField("Password", text: $password)
                case .x25519:
                    List($recipients, id: \.self) {
                        TextField("Recipient", text: $0)
                            .focused($recipientFocused)
                    }
                    Button {
                        withAnimation {
                            recipients.append("")
                        }

                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)

                            Text("Add recipient")
                        }
                    }
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            recipientFocused = true
                        }
                    }
                }
                TextField("Plaintext", text: $plaintext, axis: .vertical)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()
                    .lineLimit(10)

            }
            Section {
                Button("Encrypt") {
                    encrypting = true
                    ciphertext = ""
                    Task {
                        await encrypt()
                        password = ""
                    }
                    encrypting = false
                    copied = false
                }
                .disabled(disableButton)
            }

            if !ciphertext.isEmpty {
                Section("Output") {
                    Text(ciphertext)
                        .font(.system(size: 12, design: .monospaced))
                        .textSelection(.enabled)
                        .onTapGesture {
                            withAnimation {
                                pasteboard.string = ciphertext
                                copied = true
                            }
                        }

                    if copied {
                        Label("Copied", systemImage: "doc.on.clipboard")
                            .foregroundColor(.accentColor)
                            .font(.subheadline)
                    }
                }
                Section {
                    ShareLink(item: ciphertext)
                }
            }
        }
    }
}

extension EncryptView {
    func recipient(password: String) -> Age.ScryptRecipient? {
        Age.ScryptRecipient(password: password)
    }

    func encrypt() async {
        var out = OutputStream.toMemory()
        out.open()
        if let r = recipient(password: password) {
            let w = try? Age.encrypt(dst: &out, recipients: r)
            guard var w else {
                debugPrint("Encrypt: couldn't create output")
                return
            }
            _ = try! w.write(plaintext)
        }
        out.close()
        let enc = out.property(forKey: .dataWrittenToMemoryStreamKey) as! Data

        out = OutputStream.toMemory()
        out.open()
        var w = Armor.Writer(dst: out)
        _ = try! w.write(enc)
        try! w.close()
        out.close()
        let d = out.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
        ciphertext = String(data: d, encoding: .ascii)!
    }
}

struct EncryptView_Previews: PreviewProvider {
    static var previews: some View {
        EncryptView()
    }
}
