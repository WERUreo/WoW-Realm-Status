//
//  BlizzardCredentialsTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

@testable import Server
import Testing

@Suite("Blizzard Credentials Tests")
struct BlizzardCredentialsTests {
    @Test("Missing Client ID")
    func missingClientID() {
        #expect(throws: BlizzardCredentialsError.missingClientID) {
            try BlizzardCredentials(
                clientID: nil,
                clientSecret: "test-secret"
            )
        }
    }
    
    @Test("Missing client secret")
    func missingClientSecret() {
        #expect(throws: BlizzardCredentialsError.missingClientSecret) {
            try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: nil
            )
        }
    }
    
    @Test("Valid credentials")
    func validCredentials() throws {
        let credentials = try BlizzardCredentials(
            clientID: "test-client-id",
            clientSecret: "test-secret"
        )
        
        #expect(credentials.clientID == "test-client-id")
        #expect(credentials.clientSecret == "test-secret")
    }
}
