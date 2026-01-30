// Author: George Michelon
import SwiftUI
import DesignSystem
import CheckoutDomain
import SharedContracts

public struct CheckoutFeatureView: View {
    private let cart: Cart
    private let authObserver: AuthEventObserving
    private let context: CheckoutContextDTO

    @State private var lastAuthEvent: AuthEvent?

    public init(cart: Cart, context: CheckoutContextDTO, authObserver: AuthEventObserving) {
        self.cart = cart
        self.context = context
        self.authObserver = authObserver
    }

    public var body: some View {
        List {
            Section("Summary") {
                Text("Source: \(context.source)")
                Text("Items: \(cart.items.count)")
                Text("Total: $\(cart.total)")
            }

            Section("Authentication") {
                Text(lastAuthEventDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button("Place order") {}
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Checkout")
        .onAppear {
            authObserver.observe { event in
                lastAuthEvent = event
            }
        }
    }

    private var lastAuthEventDescription: String {
        switch lastAuthEvent {
        case .signedIn(let userID):
            return "Signed in: \(userID)"
        case .signedOut:
            return "Signed out"
        case .none:
            return "No auth events yet"
        }
    }
}
