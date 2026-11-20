//
//  Realm_StatusTests.swift
//  Realm StatusTests
//
//  Created by Keli'i Martin on 11/17/26.
//

import Testing
import Foundation
@testable import Realm_Status

@Suite("Realm Status Tests")
struct Realm_StatusTests {

    @Test("Decodes realm JSON")
    func decodesRealmJSON() throws {
        let jsonString = """
            {
                "id": 5,
                "name": "Proudmoore",
                "slug": "proudmoore",
                "status": "online",
                "population": "Full"
            }
            """
        
        let json = Data(jsonString.utf8)
        
        let realm = try JSONDecoder().decode(
            Realm.self,
            from: json
        )
        
        #expect(realm.id == 5)
        #expect(realm.name == "Proudmoore")
        #expect(realm.slug == "proudmoore")
    }
    
    @Test("Fetches realms from local Vapor server")
    func fetchesRealms() async throws {
        let service = RealmAPIService(
            baseURL: URL(string: "http://127.0.0.1:8080")!
        )
        
        let realms = try await service.fetchRealms()
        
        #expect(!realms.isEmpty)
    }
    
    @Test("Rejects unsuccessful HTTP responses")
    func rejectsUnsuccessfulResponse() async throws {
        let service = RealmAPIService(
            baseURL: URL(string: "http://127.0.0.1:8080/invalid")!
        )
        
        await #expect(throws: RealmAPIError.self) {
            try await service.fetchRealms()
        }
    }
    
}
