import Foundation
import Core
import SharedContracts

public struct NetworkClient {
    private let clock: Clock

    public init(clock: Clock = SystemClock()) {
        self.clock = clock
    }

    public func requestID() -> String {
        String(Int(clock.now().timeIntervalSince1970))
    }
}
