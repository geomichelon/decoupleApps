// Author: George Michelon
import SwiftUI
import CatalogFeature
import SharedContracts

@main
struct CatalogApp: App {
    var body: some Scene {
        WindowGroup {
            CatalogAppRootView()
        }
    }
}

private struct CatalogAppRootView: View {
    @State private var showingCheckout = false
    @State private var showingProfile = false

    var body: some View {
        NavigationStack {
            CatalogFeatureView(
                checkoutEntryPoint: AlertCheckoutEntryPoint {
                    showingCheckout = true
                },
                profileEntryPoint: AlertProfileEntryPoint {
                    showingProfile = true
                }
            )
            .alert("Checkout unavailable", isPresented: $showingCheckout) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("This app is catalog-only.")
            }
            .alert("Profile unavailable", isPresented: $showingProfile) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("This app does not include Profile.")
            }
        }
    }
}

private struct AlertCheckoutEntryPoint: CheckoutEntryPoint {
    let onTrigger: () -> Void

    func startCheckout(with context: CheckoutContextDTO) {
        _ = context
        onTrigger()
    }
}

private struct AlertProfileEntryPoint: ProfileEntryPoint {
    let onTrigger: () -> Void

    func showProfile() {
        onTrigger()
    }
}
