// Author: George Michelon
import SwiftUI
import ProfileDomain
import SharedContracts

public struct ProfileFeatureView: View {
    private let authState: AuthStateProviding
    private let authPublisher: AuthEventPublishing
    private let useCase: ProfileUseCase

    @State private var snapshot: AuthSnapshotDTO

    public init(
        authState: AuthStateProviding,
        authPublisher: AuthEventPublishing,
        useCase: ProfileUseCase = DefaultProfileUseCase()
    ) {
        self.authState = authState
        self.authPublisher = authPublisher
        self.useCase = useCase
        _snapshot = State(initialValue: authState.current)
    }

    public var body: some View {
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
                toggleAuth()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
        .navigationTitle("Profile")
        .onAppear {
            snapshot = authState.current
        }
    }

    private func toggleAuth() {
        if snapshot.isAuthenticated {
            authPublisher.publish(.signedOut)
            snapshot = .signedOut
        } else {
            let userID = "user-123"
            authPublisher.publish(.signedIn(userID: userID))
            snapshot = AuthSnapshotDTO(isAuthenticated: true, userID: userID)
        }
    }
}

public final class ProfileFeatureFactory: ObservableObject, ProfileEntryPoint {
    public init() {}

    public func showProfile() {
        // Composition root handles navigation for this entry point.
    }

    public func makeView(
        authState: AuthStateProviding,
        authPublisher: AuthEventPublishing
    ) -> ProfileFeatureView {
        ProfileFeatureView(authState: authState, authPublisher: authPublisher)
    }
}
