import SwiftUI

@main
struct AgeApp: App {
    @State private var loaded = false

    var body: some Scene {
        WindowGroup {
            if !loaded {
                LoadingView(loaded: $loaded)
            } else {
                ContentView()
            }
        }
    }
}
