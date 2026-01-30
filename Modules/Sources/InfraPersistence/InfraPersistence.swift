// Author: George Michelon
import Foundation
import Core
import SharedContracts

public struct KeyValueStore {
    private let clock: Clock
    private var storage: [String: String] = [:]

    public init(clock: Clock = SystemClock()) {
        self.clock = clock
    }

    public mutating func set(_ value: String, forKey key: String) {
        storage[key] = "\(value)@\(clock.now().timeIntervalSince1970)"
    }

    public func get(_ key: String) -> String? {
        storage[key]
    }
}
