// Author: George Michelon
import SwiftUI
import CheckoutFeature
import SharedContracts
import InfraAuth

@main
struct CheckoutApp: App {
    var body: some Scene {
        WindowGroup {
            CheckoutAppRootView()
        }
    }
}

private struct CheckoutAppRootView: View {
    @StateObject private var authStore = AuthStore()
    @StateObject private var checkoutFactory = CheckoutFeatureFactory()

    var body: some View {
        NavigationStack {
            if !authStore.current.isAuthenticated {
                SignInRequiredView {
                    authStore.publish(.signedIn(userID: "user-123"))
                }
            } else if let context = checkoutFactory.lastContext {
                CheckoutFeatureView(context: context)
                    .id(context)
            } else {
                StartCheckoutView {
                    checkoutFactory.startCheckout(with: SampleCheckout.context)
                }
            }
        }
    }
}

private struct SignInRequiredView: View {
    let onSignIn: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign in required")
                .font(.headline)
            Text("Sign in to access Checkout.")
                .foregroundStyle(.secondary)
            Button("Sign in") {
                onSignIn()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }
}

private struct StartCheckoutView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Ready to checkout")
                .font(.headline)
            Button("Start checkout") {
                onStart()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }
}

private enum SampleCheckout {
    static let context = CheckoutContextDTO(
        items: [
            CheckoutLineItemDTO(id: UUID(), name: "Starter Pack", price: 19.90, quantity: 1),
            CheckoutLineItemDTO(id: UUID(), name: "Pro Pack", price: 49.90, quantity: 1),
            CheckoutLineItemDTO(id: UUID(), name: "Add-on Support", price: 9.90, quantity: 2)
        ],
        source: "checkout"
    )
}
