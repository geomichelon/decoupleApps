import Foundation

public protocol Clock {
    func now() -> Date
}

public struct SystemClock: Clock {
    public init() {}

    public func now() -> Date {
        Date()
    }
}

public struct AppLogger {
    public init() {}

    public func log(_ message: String) {
        #if DEBUG
        print("[Core] \(message)")
        #endif
    }
}
