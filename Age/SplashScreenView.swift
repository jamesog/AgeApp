import SwiftUI

struct LoadingView: View {
    @Binding var loaded: Bool

    var body: some View {
        VStack {
            SplashScreenView()
            // TODO: Add a check for a key pair existing on the device, if not go to another screen that walks through creating one.
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    loaded = true
                }
            }
        }
    }
}

struct SplashScreenView: View {
    @State private var maxHeight: CGFloat? = nil
    @State private var spacer: Spacer? = nil

    var body: some View {

        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: maxHeight)
                .padding(.top)
            if let spacer {
                spacer
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                maxHeight = 100
                spacer = Spacer()
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
