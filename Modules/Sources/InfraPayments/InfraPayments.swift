import Foundation
import Core
import SharedContracts

public struct PaymentProcessor {
    private let clock: Clock

    public init(clock: Clock = SystemClock()) {
        self.clock = clock
    }

    public func authorize(amount: Decimal) -> Bool {
        _ = clock.now()
        return amount > 0
    }
}
