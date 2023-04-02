import SwiftUI

enum Method: String, CaseIterable {
    case scrypt = "Password"
    case x25519 = "Public keys"
}

let logoHeight: CGFloat = 100

struct ContentView: View {

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: logoHeight)

            TabView {
                EncryptView()
                    .tabItem {
                        Label("Encrypt", systemImage: "lock")
                    }
                DecryptView()
                    .tabItem {
                        Label("Decrypt", systemImage: "lock.open")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
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
