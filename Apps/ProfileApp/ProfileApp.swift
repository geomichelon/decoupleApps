// Author: George Michelon
import SwiftUI
import ProfileFeature
import InfraAuth

@main
struct ProfileApp: App {
    var body: some Scene {
        WindowGroup {
            let store = AuthStore()
            ProfileFeatureView(authStore: store)
        }
    }
}
