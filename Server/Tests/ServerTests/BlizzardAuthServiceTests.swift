//
//  BlizzardAuthServiceTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

@testable import Server
import Vapor
import VaporTesting
import Testing

@Suite("Blizzard Auth Service Tests")
struct BlizzardAuthServiceTests {
    @Test("Request access token")
    func requestAccessToken() async throws {
        try await withApp(configure: configure) { app in
            let credentials = try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: "test-client-secret"
            )
            
            let mockClient = MockClient(
                eventLoop: app.eventLoopGroup.next()
            )
            
            let authService = BlizzardAuthService(
                credentials: credentials,
                client: mockClient
            )
            
            let token = try await authService.requestAccessToken()
            
            #expect(token.accessToken == "test-access-token")
            #expect(token.tokenType == "bearer")
            #expect(token.expiresIn == 3600)
        }
    }
}
