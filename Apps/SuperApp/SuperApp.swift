// Author: George Michelon
import SwiftUI
import CatalogFeature
import CheckoutFeature
import ProfileFeature
import SharedContracts

@main
struct SuperApp: App {
    var body: some Scene {
        WindowGroup {
            SuperAppRootView()
        }
    }
}

private enum SuperTab: Hashable {
    case catalog
    case checkout
    case profile
}

private struct SuperAppRootView: View {
    @State private var selection: SuperTab = .catalog
    @StateObject private var checkoutFactory = CheckoutFeatureFactory()
    @StateObject private var authStore = AuthStore()

    var body: some View {
        TabView(selection: $selection) {
            CatalogFeatureView(
                checkoutEntryPoint: SuperCheckoutEntryPoint(factory: checkoutFactory) {
                    selection = .checkout
                },
                profileEntryPoint: SuperProfileEntryPoint {
                    selection = .profile
                }
            )
                .tabItem { Text("Catalog") }
                .tag(SuperTab.catalog)

            CheckoutFeatureView(context: checkoutFactory.lastContext ?? CheckoutContextDTO(items: [], source: "superapp"))
                .tabItem { Text("Checkout") }
                .tag(SuperTab.checkout)

            ProfileFeatureView(authState: authStore, authPublisher: authStore)
                .tabItem { Text("Profile") }
                .tag(SuperTab.profile)
        }
    }
}

private struct SuperCheckoutEntryPoint: CheckoutEntryPoint {
    let factory: CheckoutFeatureFactory
    let onCheckout: () -> Void

    func startCheckout(with context: CheckoutContextDTO) {
        factory.startCheckout(with: context)
        onCheckout()
    }
}

private struct SuperProfileEntryPoint: ProfileEntryPoint {
    let onProfile: () -> Void

    func showProfile() {
        onProfile()
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
