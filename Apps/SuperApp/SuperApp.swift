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

    var body: some View {
        TabView(selection: $selection) {
            CatalogFeatureView(checkoutEntryPoint: SuperCheckoutEntryPoint { selection = .checkout })
                .tabItem { Text("Catalog") }
                .tag(SuperTab.catalog)

            CheckoutFeatureView()
                .tabItem { Text("Checkout") }
                .tag(SuperTab.checkout)

            ProfileFeatureView()
                .tabItem { Text("Profile") }
                .tag(SuperTab.profile)
        }
    }
}

private struct SuperCheckoutEntryPoint: CheckoutEntryPoint {
    let onCheckout: () -> Void

    func startCheckout(with context: CheckoutContextDTO) {
        _ = context
        onCheckout()
    }
}
