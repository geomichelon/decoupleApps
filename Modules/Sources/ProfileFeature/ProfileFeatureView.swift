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
        let content = VStack(spacing: 16) {
            if let profile = useCase.currentProfile(from: snapshot) {
                Text("Signed in")
                    .font(.headline)
                Text("Hello, \(profile.displayName)")
                    .foregroundColor(.secondary)
            } else {
                Text("Signed out")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            actionButton(isAuthenticated: snapshot.isAuthenticated)
        }
        .padding(16)

        #if os(iOS)
        return content
            .navigationTitle("Profile")
        #else
        return content
        #endif
    }

    @ViewBuilder
    private func actionButton(isAuthenticated: Bool) -> some View {
        let label = isAuthenticated ? "Sign out" : "Sign in"
        #if os(iOS)
        Button(label) {
            toggleAuth(isAuthenticated: isAuthenticated)
        }
        .buttonStyle(.borderedProminent)
        #else
        Button(label) {
            toggleAuth(isAuthenticated: isAuthenticated)
        }
        #endif
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
