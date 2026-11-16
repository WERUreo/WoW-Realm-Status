//
//  RealmAggregationService.swift
//  Server
//
//  Created by Keli'i Martin on 11/14/26.
//

import Vapor

struct RealmAggregationService {
    let blizzardAPI: BlizzardAPIService
    
    func fetchRealms() async throws -> [Realm] {
        let index = try await blizzardAPI.fetchConnectedRealmIndex()
        
        let ids = index.realmIDs
        let maxConcurrentRequests = 3

        return try await withThrowingTaskGroup(
            of: [Realm].self,
            returning: [Realm].self
        ) { group in
            var iterator = ids.makeIterator()
            
            for _ in 0..<maxConcurrentRequests {
                guard let id = iterator.next() else {
                    break
                }
                
                group.addTask {
                    let connectedRealm = try await blizzardAPI.fetchConnectedRealm(id: id)
                    return Self.mapRealms(from: connectedRealm)
                }
            }
            
            var realms: [Realm] = []
            
            for try await result in group {
                realms.append(contentsOf: result)
                
                if let id = iterator.next() {
                    group.addTask {
                        let connectedRealm = try await blizzardAPI.fetchConnectedRealm(id: id)
                        return Self.mapRealms(from: connectedRealm)
                    }
                }
            }
            
            return realms
        }
    }
    
    static func mapRealms(from connectedRealm: BlizzardConnectedRealm) -> [Realm] {
        let status = RealmStatus(
            blizzardStatus: connectedRealm.status.type
        )
        
        return connectedRealm.realms.map { realm in
            Realm(
                id: realm.id,
                name: realm.name,
                slug: realm.slug,
                status: status,
                population: connectedRealm.population.name
            )
        }
    }
}
