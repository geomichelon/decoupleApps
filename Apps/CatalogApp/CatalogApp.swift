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

    var body: some View {
        NavigationStack {
            CatalogFeatureView(
                checkoutEntryPoint: AlertCheckoutEntryPoint {
                    showingCheckout = true
                }
            )
            .alert("Checkout unavailable", isPresented: $showingCheckout) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("This app is catalog-only.")
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
