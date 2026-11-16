//
//  RealmCache.swift
//  Server
//
//  Created by Keli'i Martin on 11/16/26.
//

import Foundation

actor RealmCache {
    private var realms: [Realm]?
    private var lastUpdated: Date?
    private var refreshTask: Task<[Realm], any Error>?
    private var refreshID: UUID?
    
    private let cacheDuration: TimeInterval
    private let now: @Sendable () -> Date
    
    init(
        cacheDuration: TimeInterval = 60,
    now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.cacheDuration = cacheDuration
        self.now = now
    }
    
    func get() -> [Realm]? {
        guard let realms,
              let lastUpdated,
              now().timeIntervalSince(lastUpdated) < cacheDuration else {
            return nil
        }
        
        return realms
    }
    
    func store(_ realms: [Realm]) {
        self.realms = realms
        self.lastUpdated = now()
    }
    
    func getOrFetch(
        using fetch: @escaping @Sendable () async throws -> [Realm]
    ) async throws -> [Realm] {
        if let cached = get() {
            return cached
        }
        
        if let refreshTask {
            return try await refreshTask.value
        }
        
        let id = UUID()
        
        let task = Task {
            try await fetch()
        }
        
        refreshTask = task
        refreshID = id
        
        do {
            let realms = try await task.value
            
            if refreshID == id {
                store(realms)
                refreshTask = nil
                refreshID = nil
            }
            
            return realms
        } catch {
            if refreshID == id {
                refreshTask = nil
                refreshID = nil
            }

            throw error
        }
    }
}
