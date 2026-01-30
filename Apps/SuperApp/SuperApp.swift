// Author: George Michelon
import SwiftUI
import CatalogFeature
import CatalogDomain
import CheckoutFeature
import CheckoutDomain
import ProfileFeature
import SharedContracts
import InfraAuth

@main
struct SuperApp: App {
    private let authBus = AuthEventBus()

    var body: some Scene {
        WindowGroup {
            SuperAppRootView(authBus: authBus)
        }
    }
}

private enum SuperAppRoute: Hashable {
    case checkout(CheckoutContextDTO)
}

private struct SuperAppRootView: View {
    let authBus: AuthEventBus

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink("Catalog") {
                    CatalogFeatureView(
                        items: SampleData.catalogItems,
                        checkoutRouter: CheckoutRouter(path: $path)
                    )
                }

                NavigationLink("Profile") {
                    ProfileFeatureView(authPublisher: authBus)
                }
            }
            .navigationTitle("SuperApp")
            .navigationDestination(for: SuperAppRoute.self) { route in
                switch route {
                case .checkout(let context):
                    CheckoutFeatureView(
                        cart: SampleData.cart(from: context),
                        context: context,
                        authObserver: authBus
                    )
                }
            }
        }
    }
}

private struct CheckoutRouter: CheckoutRouting {
    let path: Binding<NavigationPath>

    func startCheckout(with context: CheckoutContextDTO) {
        path.wrappedValue.append(SuperAppRoute.checkout(context))
    }
}

private enum SampleData {
    static let catalogItems = [
        CatalogItem(id: UUID(), title: "Starter Pack", price: 19.90),
        CatalogItem(id: UUID(), title: "Pro Pack", price: 49.90)
    ]

    static func cart(from context: CheckoutContextDTO) -> Cart {
        Cart(items: context.items)
    }
}
