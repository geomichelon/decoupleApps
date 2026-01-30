// Author: George Michelon
import SwiftUI
import Combine
import CatalogFeature
import CheckoutFeature
import ProfileFeature
import SharedContracts
import InfraAuth

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
                checkoutEntryPoint: SuperCheckoutEntryPoint(
                    factory: checkoutFactory,
                    authState: authStore,
                    onCheckout: { selection = .checkout },
                    onDenied: { selection = .profile }
                ),
                profileEntryPoint: SuperProfileEntryPoint {
                    selection = .profile
                }
            )
                .tabItem { Text("Catalog") }
                .tag(SuperTab.catalog)

            checkoutTab
                .tabItem { Text("Checkout") }
                .tag(SuperTab.checkout)

            ProfileFeatureView(authStore: authStore)
                .tabItem { Text("Profile") }
                .tag(SuperTab.profile)
        }
    }

    @ViewBuilder
    private var checkoutTab: some View {
        if !authStore.current.isAuthenticated {
            SignInRequiredView(action: { selection = .profile })
        } else if let context = checkoutFactory.lastContext {
            CheckoutFeatureView(context: context)
                .id(context)
        } else {
            CheckoutEmptyStateView()
        }
    }
}

private struct SuperCheckoutEntryPoint: CheckoutEntryPoint {
    let factory: CheckoutFeatureFactory
    let authState: AuthStateProviding
    let onCheckout: () -> Void
    let onDenied: () -> Void

    func startCheckout(with context: CheckoutContextDTO) {
        guard authState.current.isAuthenticated else {
            onDenied()
            return
        }
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

private struct SignInRequiredView: View {
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign in required")
                .font(.headline)
            Text("Please sign in from Profile to access Checkout.")
                .foregroundStyle(.secondary)
            Button("Go to Profile") {
                action()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }
}

private struct CheckoutEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("No checkout in progress")
                .font(.headline)
            Text("Start a checkout from Catalog.")
                .foregroundStyle(.secondary)
        }
        .padding(16)
    }
}
