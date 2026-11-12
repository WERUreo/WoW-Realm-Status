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
                clientSecret: "test-secret"
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
    
    @Test("Rejects failed OAuth authentication")
    func rejectsFailedAuthentication() async throws {
        try await withApp(configure: configure) { app in
            let credentials = try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: "test-secret"
            )
            
            let mockClient = MockClient(
                eventLoop: app.eventLoopGroup.next(),
                responseStatus: .unauthorized
            )
            
            let authService = BlizzardAuthService(
                credentials: credentials,
                client: mockClient
            )
            
            await #expect {
                try await authService.requestAccessToken()
            } throws: { error in
                guard let abort = error as? Abort else {
                    return false
                }
                
                return abort.status == .badGateway
            }
        }
    }
}
