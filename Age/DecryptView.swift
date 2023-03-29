import SwiftUI

struct DecryptView: View {
    @State private var method = Method.scrypt
    @State private var password = ""
    @State private var ciphertext = ""


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
                    Spacer()
                }

                TextField("ASCII Armored PEM", text: $ciphertext, axis: .vertical)
                    .lineLimit(5...)
            }

            Section {
                Button("Decrypt") {

                }
            }
        }
    }
}

struct DecryptView_Previews: PreviewProvider {
    static var previews: some View {
        DecryptView()
    }
}
