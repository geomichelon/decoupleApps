// Author: George Michelon
import SwiftUI
import ProfileDomain
import SharedContracts

public struct ProfileFeatureView<AuthStoreType>: View where AuthStoreType: ObservableObject & AuthStateProviding & AuthEventPublishing {
    @ObservedObject private var authStore: AuthStoreType
    private let useCase: ProfileUseCase

    public init(
        authStore: AuthStoreType,
        useCase: ProfileUseCase = DefaultProfileUseCase()
    ) {
        self.authStore = authStore
        self.useCase = useCase
    }

    public var body: some View {
        let snapshot = authStore.current
        VStack(spacing: 16) {
            if let profile = useCase.currentProfile(from: snapshot) {
                Text("Signed in")
                    .font(.headline)
                Text("Hello, \(profile.displayName)")
                    .foregroundStyle(.secondary)
            } else {
                Text("Signed out")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Button(snapshot.isAuthenticated ? "Sign out" : "Sign in") {
                toggleAuth(isAuthenticated: snapshot.isAuthenticated)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
        .navigationTitle("Profile")
    }

    private func toggleAuth(isAuthenticated: Bool) {
        if isAuthenticated {
            authStore.publish(.signedOut)
        } else {
            let userID = "user-123"
            authStore.publish(.signedIn(userID: userID))
        }
    }
}

public final class ProfileFeatureFactory: ObservableObject, ProfileEntryPoint {
    public init() {}

    public func showProfile() {
        // Composition root handles navigation for this entry point.
    }

    public func makeView<AuthStoreType>(
        authStore: AuthStoreType
    ) -> ProfileFeatureView<AuthStoreType> where AuthStoreType: ObservableObject & AuthStateProviding & AuthEventPublishing {
        ProfileFeatureView(authStore: authStore)
    }
}
