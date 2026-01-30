// Author: George Michelon
import SwiftUI
import DesignSystem
import CatalogDomain
import SharedContracts

public struct CatalogFeatureView: View {
    private let items: [CatalogItem]
    private let checkoutRouter: CheckoutRouting

    public init(items: [CatalogItem], checkoutRouter: CheckoutRouting) {
        self.items = items
        self.checkoutRouter = checkoutRouter
    }

    public var body: some View {
        List {
            Section("Catalog") {
                ForEach(items) { item in
                    Card {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title).font(.headline)
                                Text("$\(item.price)").font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                }
            }

            Section {
                Button("Go to Checkout") {
                    let lineItems = items.map {
                        CheckoutLineItemDTO(id: $0.id, name: $0.title, price: $0.price, quantity: 1)
                    }
                    let context = CheckoutContextDTO(items: lineItems, source: "catalog")
                    checkoutRouter.startCheckout(with: context)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Catalog")
    }
}
