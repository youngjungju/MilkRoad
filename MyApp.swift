import SwiftUI
import AVFoundation

@main
struct MyApp: App {
    init() {
        playSound(sound: "milk_road")
        FontManager.registerFonts()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
