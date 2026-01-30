// Author: George Michelon
import Foundation

// MARK: - Entry Points

public protocol CheckoutEntryPoint {
    func startCheckout(with context: CheckoutContextDTO)
}

public protocol ProfileEntryPoint {
    func showProfile()
}

// MARK: - DTOs

public struct CheckoutLineItemDTO: Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let price: Decimal
    public let quantity: Int

    public init(id: UUID, name: String, price: Decimal, quantity: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

public struct CheckoutContextDTO: Hashable, Sendable {
    public let items: [CheckoutLineItemDTO]
    public let source: String

    public init(items: [CheckoutLineItemDTO], source: String) {
        self.items = items
        self.source = source
    }
}

public struct AuthSnapshotDTO: Hashable, Sendable {
    public let isAuthenticated: Bool
    public let userID: String?

    public init(isAuthenticated: Bool, userID: String?) {
        self.isAuthenticated = isAuthenticated
        self.userID = userID
    }

    public static let signedOut = AuthSnapshotDTO(isAuthenticated: false, userID: nil)
}

// MARK: - Events / Publishers

public enum AuthEvent: Hashable, Sendable {
    case signedIn(userID: String)
    case signedOut
}

public protocol AuthEventPublishing {
    func publish(_ event: AuthEvent)
}

public protocol AuthEventObserving {
    func observe(_ handler: @escaping (AuthEvent) -> Void)
}

public protocol AuthStateProviding {
    var current: AuthSnapshotDTO { get }
}
