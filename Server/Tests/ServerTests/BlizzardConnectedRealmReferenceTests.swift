//
//  BlizzardConnectedRealmReferenceTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/14/26.
//

import Foundation
import Testing
@testable import Server

@Suite("Blizzard Connected Realm Reference Tests")
struct BlizzardConnectedRealmReferenceTests {
    @Test("Extracts connected realm ID")
    func extractsConnectedRealmID() {
        let reference = BlizzardConnectedRealmReference(
            href: "https://us.api.blizzard.com/data/wow/connected-realm/121?namespace=dynamic-us"
        )
        
        #expect(reference.id == 121)
    }
    
    @Test("Returns nil when the URL contains a nonnumeric realm ID")
    func rejectsNonnumericConnectedRealmID() {
        let reference = BlizzardConnectedRealmReference(
            href: "https://us.api.blizzard.com/data/wow/connected-realm/invalid?namespace=dynamic-us"
        )
        
        #expect(reference.id == nil)
    }
    
    @Test("Extracts valid connected realm IDs from an index")
    func extractsConnectedRealmIDs() {
        let index = BlizzardConnectedRealmIndex(
            connectedRealms: [
                BlizzardConnectedRealmReference(
                    href: "https://us.api.blizzard.com/data/wow/connected-realm/121?namespace=dynamic-us"
                ),
                BlizzardConnectedRealmReference(
                    href: "https://us.api.blizzard.com/data/wow/connected-realm/invalid?namespace=dynamic-us"
                ),
                BlizzardConnectedRealmReference(
                    href: "https://us.api.blizzard.com/data/wow/connected-realm/127?namespace=dynamic-us"
                )
            ]
        )

        #expect(index.realmIDs == [121, 127])
    }}
