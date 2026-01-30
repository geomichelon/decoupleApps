// Author: George Michelon
import Foundation
import Core
import SharedContracts

public final class AuthEventBus: AuthEventPublishing, AuthEventObserving, AuthStateProviding {
    private let logger: AppLogger
    private var observers: [UUID: (AuthEvent) -> Void] = [:]

    public private(set) var current: AuthSnapshotDTO

    public init(initial: AuthSnapshotDTO = .signedOut, logger: AppLogger = AppLogger()) {
        self.current = initial
        self.logger = logger
    }

    public func publish(_ event: AuthEvent) {
        switch event {
        case .signedIn(let userID):
            current = AuthSnapshotDTO(isAuthenticated: true, userID: userID)
        case .signedOut:
            current = .signedOut
        }
        logger.log("Auth event: \(event)")
        observers.values.forEach { $0(event) }
    }

    public func observe(_ handler: @escaping (AuthEvent) -> Void) {
        let id = UUID()
        observers[id] = handler
        handler(current.isAuthenticated ? .signedIn(userID: current.userID ?? "") : .signedOut)
    }
}
