import SwiftUI

enum Method: String, CaseIterable {
    case scrypt = "Password"
    case x25519 = "Public keys"
}

let logoHeight: CGFloat = 100

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab = Tab.decrypt

    enum Tab: Int {
        case encrypt
        case decrypt
        case settings
    }

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: logoHeight)

            TabView(selection: $selectedTab) {
                EncryptView()
                    .tabItem {
                        Label("Encrypt", systemImage: "lock")
                    }
                    .tag(Tab.encrypt)
                DecryptView()
                    .tabItem {
                        Label("Decrypt", systemImage: "lock.open")
                    }
                    .tag(Tab.decrypt)
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(Tab.settings)
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
