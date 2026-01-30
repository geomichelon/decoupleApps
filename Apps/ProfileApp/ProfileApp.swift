// Author: George Michelon
import SwiftUI
import ProfileFeature
import SharedContracts

@main
struct ProfileApp: App {
    var body: some Scene {
        WindowGroup {
            let store = AuthStore()
            ProfileFeatureView(authState: store, authPublisher: store)
        }
    }
}

private final class AuthStore: ObservableObject, AuthStateProviding, AuthEventPublishing {
    @Published private(set) var current: AuthSnapshotDTO = .signedOut

    func publish(_ event: AuthEvent) {
        switch event {
        case .signedIn(let userID):
            current = AuthSnapshotDTO(isAuthenticated: true, userID: userID)
        case .signedOut:
            current = .signedOut
        }
    }
}
