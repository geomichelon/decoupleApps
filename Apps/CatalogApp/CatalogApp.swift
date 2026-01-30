// Author: George Michelon
import SwiftUI
import CatalogFeature
import CatalogDomain
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
                items: SampleData.catalogItems,
                checkoutRouter: CatalogCheckoutRouter { _ in
                    showingCheckout = true
                }
            )
            .navigationTitle("Catalog")
            .alert("Checkout unavailable", isPresented: $showingCheckout) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("This app is catalog-only.")
            }
        }
    }
}

private struct CatalogCheckoutRouter: CheckoutRouting {
    let onRoute: (CheckoutContextDTO) -> Void

    func startCheckout(with context: CheckoutContextDTO) {
        onRoute(context)
    }
}

private enum SampleData {
    static let catalogItems = [
        CatalogItem(id: UUID(), title: "Starter Pack", price: 19.90),
        CatalogItem(id: UUID(), title: "Pro Pack", price: 49.90)
    ]
}
