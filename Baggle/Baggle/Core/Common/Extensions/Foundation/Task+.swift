//
//  Task+.swift
//  Baggle
//
//  Created by youtak on 2023/08/21.
//

import Foundation

import ComposableArchitecture

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

extension Task where Failure == Error {
    @discardableResult
    static func retrying(
        priority: TaskPriority? = nil,
        maxRetryCount: Int = 1,
        retryDelay: TimeInterval = 0.4,
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            @Dependency(\.tokenRefreshService) var refreshService
            
            for _ in 0..<maxRetryCount {
                do {
                    return try await operation()
                } catch {
                    if let error = error as? APIError {
                        if error == .unauthorized {
                            if await refreshService.refresh() == .success { continue }
                        }
                    }
                    print("✅ retrying")
                    try await Task<Never, Never>.sleep(seconds: retryDelay)
                    continue
                }
            }
            
            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
