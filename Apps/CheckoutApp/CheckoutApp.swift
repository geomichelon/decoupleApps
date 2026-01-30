// Author: George Michelon
import SwiftUI
import CheckoutFeature
import CheckoutDomain
import SharedContracts
import InfraAuth

@main
struct CheckoutApp: App {
    private let authBus = AuthEventBus()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CheckoutFeatureView(
                    cart: SampleData.cart,
                    context: SampleData.context,
                    authObserver: authBus
                )
            }
        }
    }
}

private enum SampleData {
    static let items = [
        CheckoutLineItemDTO(id: UUID(), name: "Starter Pack", price: 19.90, quantity: 1)
    ]

    static let context = CheckoutContextDTO(items: items, source: "checkout")
    static let cart = Cart(items: items)
}
