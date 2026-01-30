import SwiftUI
import DesignSystem
import ProfileDomain
import SharedContracts

public struct ProfileFeatureView: View {
    private let authPublisher: AuthEventPublishing

    @State private var isAuthenticated = false

    public init(authPublisher: AuthEventPublishing) {
        self.authPublisher = authPublisher
    }

    public var body: some View {
        VStack(spacing: DS.spacing) {
            Text(isAuthenticated ? "Autenticado" : "Deslogado")
                .font(.headline)

            Button(isAuthenticated ? "Sair" : "Entrar") {
                isAuthenticated.toggle()
                if isAuthenticated {
                    authPublisher.publish(.signedIn(userID: "user-123"))
                } else {
                    authPublisher.publish(.signedOut)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(DS.spacing)
        .navigationTitle("Profile")
    }
}
