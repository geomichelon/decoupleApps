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
            Section("Resumo") {
                Text("Origem: \(context.source)")
                Text("Itens: \(cart.items.count)")
                Text("Total: R$ \(cart.total)")
            }

            Section("Autenticação") {
                Text(lastAuthEventDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button("Finalizar pedido") {}
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
            return "Usuário autenticado: \(userID)"
        case .signedOut:
            return "Usuário deslogado"
        case .none:
            return "Sem eventos de autenticação ainda"
        }
    }
}
