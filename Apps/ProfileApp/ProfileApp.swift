// Author: George Michelon
import SwiftUI
import ProfileFeature
import SharedContracts
import InfraAuth

@main
struct ProfileApp: App {
    private let authBus = AuthEventBus()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ProfileFeatureView(authPublisher: authBus)
            }
        }
    }
}
