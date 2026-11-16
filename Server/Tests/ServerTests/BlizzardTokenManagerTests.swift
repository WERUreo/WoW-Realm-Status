//
//  BlizzardTokenManagerTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/12/26.
//

import Testing
import Vapor
import VaporTesting
@testable import Server

@Suite("Blizzard Token Manager Tests")
struct BlizzardTokenManagerTests {
    @Test("Returns an access token from Blizzard")
    func returnsAccessToken() async throws {
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
            
            let tokenManager = BlizzardTokenManager(
                authService: authService
            )
            
            let token = try await tokenManager.getAccessToken()
            
            #expect(token == "test-access-token")
        }
    }
    
    @Test("Reuses a cached access token")
    func reusesCachedAccessToken() async throws {
        try await withApp(configure: configure) { app in
            let credentials = try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: "test-secret"
            )
            
            let counter = RequestCounter()
            
            let mockClient = MockClient(
                eventLoop: app.eventLoopGroup.next(),
                requestCounter: counter
            )
            
            let authService = BlizzardAuthService(
                credentials: credentials,
                client: mockClient
            )
            
            let tokenManager = BlizzardTokenManager(
                authService: authService
            )
            
            let firstToken = try await tokenManager.getAccessToken()
            let secondToken = try await tokenManager.getAccessToken()
            
            #expect(firstToken == secondToken)
            #expect(counter.value == 1)
        }
    }
    
    @Test("Refreshes an expired access token")
    func refreshesExpiredAccessToken() async throws {
        try await withApp(configure: configure) { app in
            let credentials = try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: "test-secret"
            )
            
            let counter = RequestCounter()
            
            let mockClient = MockClient(
                eventLoop: app.eventLoopGroup.next(),
                requestCounter: counter,
                tokenExpiresIn: 0
            )
            
            let authService = BlizzardAuthService(
                credentials: credentials,
                client: mockClient
            )
            
            let tokenManager = BlizzardTokenManager(
                authService: authService
            )
            
            _ = try await tokenManager.getAccessToken()
            _ = try await tokenManager.getAccessToken()
            
            #expect(counter.value == 2)
        }
    }
    
    @Test("Shares authentication across concurrent requests")
    func sharesConcurrentAuthentication() async throws {
        try await withApp(configure: configure) { app in
            let credentials = try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: "test-secret"
            )
            
            let counter = RequestCounter()
            
            let mockClient = MockClient(
                eventLoop: app.eventLoopGroup.next(),
                requestCounter: counter,
                responseDelay: .milliseconds(250)
            )
            
            let authService = BlizzardAuthService(
                credentials: credentials,
                client: mockClient
            )
            
            let tokenManager = BlizzardTokenManager(
                authService: authService
            )
            
            let tokens = try await withThrowingTaskGroup(
                of: String.self
            ) { group in
                for _ in 0..<5 {
                    group.addTask {
                        try await tokenManager.getAccessToken()
                    }
                }
                
                var results: [String] = []
                
                for try await token in group {
                    results.append(token)
                }
                
                return results
            }
            
            #expect(tokens.count == 5)
            #expect(tokens.allSatisfy { $0 == "test-access-token" })
            #expect(counter.value == 1)
        }
    }
    
    @Test("Clears failed authentication task")
    func clearsFailedAuthenticationTask() async throws {
        try await withApp(configure: configure) { app in
            let credentials = try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: "test-secret"
            )
            
            let counter = RequestCounter()
            
            let mockClient = MockClient(
                eventLoop: app.eventLoopGroup.next(),
                responseStatus: .unauthorized,
                requestCounter: counter
            )
            
            let authService = BlizzardAuthService(
                credentials: credentials,
                client: mockClient
            )
            
            let tokenManager = BlizzardTokenManager(
                authService: authService
            )
            
            for _ in 0..<2 {
                await #expect {
                    try await tokenManager.getAccessToken()
                } throws: { error in
                    guard let abort = error as? Abort else {
                        return false
                    }
                    
                    return abort.status == .badGateway
                }
            }
            
            #expect(counter.value == 2)
        }
    }
    
    @Test("Shares failed authentication across concurrent requests")
    func sharesConcurrentAuthenticationFailure() async throws {
        try await withApp(configure: configure) { app in
            let credentials = try BlizzardCredentials(
                clientID: "test-client-id",
                clientSecret: "test-secret"
            )
            
            let counter = RequestCounter()
            
            let mockClient = MockClient(
                eventLoop: app.eventLoopGroup.next(),
                responseStatus: .unauthorized,
                requestCounter: counter,
                responseDelay: .milliseconds(250)
            )
            
            let authService = BlizzardAuthService(
                credentials: credentials,
                client: mockClient
            )
            
            let tokenManager = BlizzardTokenManager(
                authService: authService
            )
            
            await withTaskGroup(of: Bool.self) { group in
                for _ in 0..<5 {
                    group.addTask {
                        do {
                            _ = try await tokenManager.getAccessToken()
                            return false
                        } catch let error as Abort {
                            return error.status == .badGateway
                        } catch {
                            return false
                        }
                    }
                }
                
                var results: [Bool] = []
                
                for await result in group {
                    results.append(result)
                }
                
                #expect(results.count == 5)
                #expect(results.allSatisfy { $0 })
            }
            
            #expect(counter.value == 1)
        }
    }
}
