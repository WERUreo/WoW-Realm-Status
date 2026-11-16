//
//  RealmAggregationServiceTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/16/26.
//

import Testing
@testable import Server

@Suite("Realm Aggregation Server Tests")
struct RealmAggregationServiceTests {
    @Test("Maps connected realm members to individual realms")
    func mapsConnectedRealmMembers() {
        let connectedRealm = BlizzardConnectedRealm(
            id: 121,
            status: BlizzardRealmValue(type: "UP", name: "Up"),
            population: BlizzardRealmValue(type: "HIGH", name: "High"),
            realms: [
                BlizzardRealm(
                    id: 121,
                    name: "Azjol-Nerub",
                    slug: "azjolnerub"
                ),
                BlizzardRealm(
                    id: 1182,
                    name: "Muradin",
                    slug: "muradin"
                )
            ]
        )
        
        let realms = RealmAggregationService.mapRealms(
            from: connectedRealm
        )
        
        #expect(realms.count == 2)
        #expect(realms[0].id == 121)
        #expect(realms[0].name == "Azjol-Nerub")
        #expect(realms[1].id == 1182)
        #expect(realms[1].name == "Muradin")
        
        #expect(realms.allSatisfy { $0.status == .online })
        #expect(realms.allSatisfy { $0.population == "High" })
    }
}
