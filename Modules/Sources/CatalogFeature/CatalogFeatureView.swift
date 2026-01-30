// Author: George Michelon
import SwiftUI
import CatalogDomain
import SharedContracts

public struct CatalogFeatureView: View {
    private let useCase: CatalogUseCase
    private let checkoutEntryPoint: CheckoutEntryPoint

    @State private var items: [CatalogItem] = []
    @State private var didTriggerCheckout = false

    public init(
        useCase: CatalogUseCase = DefaultCatalogUseCase(),
        checkoutEntryPoint: CheckoutEntryPoint = NoopCheckoutEntryPoint()
    ) {
        self.useCase = useCase
        self.checkoutEntryPoint = checkoutEntryPoint
    }

    public var body: some View {
        List {
            Section("Catalog") {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                        Text("$\(item.price)")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Button("Go to Checkout") {
                    let lineItems = items.map {
                        CheckoutLineItemDTO(
                            id: $0.id,
                            name: $0.title,
                            price: $0.price,
                            quantity: 1
                        )
                    }
                    let context = CheckoutContextDTO(items: lineItems, source: "catalog")
                    checkoutEntryPoint.startCheckout(with: context)
                    didTriggerCheckout = true
                }
                .disabled(items.isEmpty)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Catalog")
        .onAppear {
            items = useCase.fetchItems()
        }
        .alert("Checkout started", isPresented: $didTriggerCheckout) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The checkout flow was triggered via entry point.")
        }
    }
}

public struct NoopCheckoutEntryPoint: CheckoutEntryPoint {
    public init() {}

    public func startCheckout(with context: CheckoutContextDTO) {
        _ = context
    }
}
