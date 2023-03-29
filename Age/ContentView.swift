import SwiftUI

struct ContentView: View {
    @State private var plaintext = ""
    @State private var method: Methods = .scrypt
    enum Methods: String, CaseIterable {
        case scrypt = "Password"
        case x25519 = "Public keys"
    }

    @State private var password = ""
    @State private var recipients: [String] = []
    @FocusState private var recipientFocused: Bool

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)

            Spacer()

            Form {
                Section {
                    Picker("Encryption method", selection: $method.animation()) {
                        ForEach(Methods.allCases, id: \.self) {
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

                    }
                    .disabled(plaintext.isEmpty || password.isEmpty)
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button {

                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
