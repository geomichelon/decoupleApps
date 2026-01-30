// Author: George Michelon
import SwiftUI
import CheckoutDomain
import SharedContracts

public struct CheckoutFeatureView: View {
    @StateObject private var viewModel: CheckoutViewModel

    public init(context: CheckoutContextDTO) {
        _viewModel = StateObject(wrappedValue: CheckoutViewModel(context: context))
    }

    public var body: some View {
        List {
            Section("Items") {
                ForEach(viewModel.items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.headline)
                            Text("$\(item.price)")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Stepper(
                            value: binding(for: item),
                            in: 1...99
                        ) {
                            Text("Qty \(item.quantity)")
                        }
                        .frame(maxWidth: 140)
                    }
                }
                .onDelete(perform: viewModel.removeItems)
            }

            Section("Summary") {
                Text("Subtotal: $\(viewModel.subtotal)")
                Text("Total: $\(viewModel.total)")
            }

            Section {
                Button("Place order") {
                    viewModel.placeOrder()
                }
                .disabled(viewModel.items.isEmpty)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Checkout")
        .alert("Order placed", isPresented: $viewModel.showOrderAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This is a placeholder checkout flow.")
        }
    }

    private func binding(for item: CartItem) -> Binding<Int> {
        Binding<Int>(
            get: { item.quantity },
            set: { newValue in
                viewModel.updateQuantity(for: item.id, quantity: newValue)
            }
        )
    }
}

public final class CheckoutViewModel: ObservableObject {
    @Published private(set) var cart: Cart
    @Published var showOrderAlert = false

    init(context: CheckoutContextDTO) {
        self.cart = (try? Cart(context: context)) ?? Cart()
    }

    var items: [CartItem] { cart.items }
    var subtotal: Decimal { cart.subtotal }
    var total: Decimal { cart.total }

    func updateQuantity(for id: UUID, quantity: Int) {
        do {
            try cart.updateQuantity(id: id, quantity: quantity)
            objectWillChange.send()
        } catch {
            return
        }
    }

    func removeItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let id = cart.items[index].id
            try? cart.remove(id: id)
        }
        objectWillChange.send()
    }

    func placeOrder() {
        showOrderAlert = true
    }
}

public final class CheckoutFeatureFactory: ObservableObject, CheckoutEntryPoint {
    @Published public private(set) var lastContext: CheckoutContextDTO?

    public init() {}

    public func startCheckout(with context: CheckoutContextDTO) {
        lastContext = context
    }

    public func makeView(context: CheckoutContextDTO) -> CheckoutFeatureView {
        CheckoutFeatureView(context: context)
    }
}
