// Author: George Michelon
import SwiftUI
import CatalogDomain
import SharedContracts

public struct CatalogFeatureView: View {
    private let useCase: CatalogUseCase
    private let checkoutEntryPoint: CheckoutEntryPoint
    private let profileEntryPoint: ProfileEntryPoint

    @State private var items: [CatalogItem] = []

    public init(
        useCase: CatalogUseCase = DefaultCatalogUseCase(),
        checkoutEntryPoint: CheckoutEntryPoint = NoopCheckoutEntryPoint(),
        profileEntryPoint: ProfileEntryPoint = NoopProfileEntryPoint()
    ) {
        self.useCase = useCase
        self.checkoutEntryPoint = checkoutEntryPoint
        self.profileEntryPoint = profileEntryPoint
    }

    public var body: some View {
        let content = List {
            Section("Catalog") {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                        Text("$\(item.price)")
                            .foregroundColor(.secondary)
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
                }
                .disabled(items.isEmpty)
            }

            Section {
                Button("Go to Profile") {
                    profileEntryPoint.showProfile()
                }
            }
        }
        .onAppear {
            items = useCase.fetchItems()
        }

        #if os(iOS)
        return content
            .listStyle(.insetGrouped)
            .navigationTitle("Catalog")
        #else
        return content
        #endif
    }
}

public struct NoopCheckoutEntryPoint: CheckoutEntryPoint {
    public init() {}

    public func startCheckout(with context: CheckoutContextDTO) {
        _ = context
    }
}

public struct NoopProfileEntryPoint: ProfileEntryPoint {
    public init() {}

    public func showProfile() {}
}
