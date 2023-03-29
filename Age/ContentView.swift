import SwiftUI

enum Method: String, CaseIterable {
    case scrypt = "Password"
    case x25519 = "Public keys"
}

struct ContentView: View {

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)

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
