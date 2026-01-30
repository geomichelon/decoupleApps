// Author: George Michelon
import Foundation
import Core
import SharedContracts

public protocol AnalyticsTracking {
    func track(_ event: String)
}

public struct NoopAnalytics: AnalyticsTracking {
    private let logger: AppLogger

    public init(logger: AppLogger = AppLogger()) {
        self.logger = logger
    }

    public func track(_ event: String) {
        logger.log("Analytics: \(event)")
    }
}
