//
//  RealmCacheTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/16/26.
//

import Testing
import Foundation
@testable import Server

@Suite("Realm Cache Tests")
struct RealmCacheTests {
    @Test("Empty cache returns nil")
    func emptyCacheReturnsNil() async {
        let cache = RealmCache()
        
        let result = await cache.get()
        
        #expect(result == nil)
    }
    
    @Test("Stored realms can be retrieved")
    func storedRealmsCanBeRetrieved() async {
        let cache = RealmCache()
        
        let realm = Realm(
            id: 5,
            name: "Proudmoore",
            slug: "proudmoore",
            status: .online,
            population: "Full"
        )
        
        await cache.store([realm])
        
        let result = await cache.get()
        
        #expect(result?.count == 1)
        #expect(result?.first?.id == 5)
        #expect(result?.first?.name == "Proudmoore")
        #expect(result?.first?.status ==  .online)
        #expect(result?.first?.population == "Full")
    }
    
    @Test("Expired cache returns nil")
    func expiredCacheReturnsNil() async {
        let cache = RealmCache(cacheDuration: 0)
        
        let realm = Realm(
            id: 5,
            name: "Proudmoore",
            slug: "proudmoore",
            status: .online,
            population: "Full"
        )
        
        await cache.store([realm])
        
        let result = await cache.get()
        
        #expect(result == nil)
    }
    
    @Test("Concurrent callers share a single refresh")
    func concurrentCallersShareRefresh() async throws {
        let cache = RealmCache()
        let counter = FetchCounter()
        
        let fetch: @Sendable () async throws -> [Realm] = {
            await counter.increment()
            
            try await Task.sleep(for: .milliseconds(200))
            
            return [
                Realm(
                    id: 5,
                    name: "Proudmoore",
                    slug: "proudmoore",
                    status: .online,
                    population: "Full"
                )
            ]
        }
        
        async let first = cache.getOrFetch(using: fetch)
        async let second = cache.getOrFetch(using: fetch)
        async let third = cache.getOrFetch(using: fetch)
        
        let results = try await [first, second, third]
        
        #expect(results.count == 3)
        #expect(results.allSatisfy { $0.count == 1 })
        
        let fetchCount = await counter.count
        #expect(fetchCount == 1)
    }
    
    private actor FetchCounter {
        private(set) var count = 0
        
        func increment() {
            count += 1
        }
    }
}
