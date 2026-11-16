//
//  BlizzardAPIService.swift
//  Server
//
//  Created by Keli'i Martin on 11/13/26.
//

import Vapor

struct BlizzardAPIService {
    let client: any Client
    let tokenManager: BlizzardTokenManager
    
    func fetchRealmIndex() async throws -> BlizzardRealmIndexResponse {
        let accessToken = try await tokenManager.getAccessToken()
        
        let response = try await client.get(
            URI(string: "https://us.api.blizzard.com/data/wow/realm/index")
        ) { request in
            request.headers.bearerAuthorization = BearerAuthorization(
                token: accessToken
            )
            
            try request.query.encode([
                "namespace": "dynamic-us",
                "locale": "en_US"
            ])
        }
        
        guard response.status == .ok else {
            throw Abort(
                .badGateway,
                reason: "Failed to fetch Blizzard realm index"
            )
        }
        
        return try response.content.decode(BlizzardRealmIndexResponse.self)
    }
    
    func fetchConnectedRealm(id: Int) async throws -> BlizzardConnectedRealm {
        let accessToken = try await tokenManager.getAccessToken()
        
        let response = try await client.get(
            URI(string: "https://us.api.blizzard.com/data/wow/connected-realm/\(id)")
        ) { request in
            request.headers.bearerAuthorization = BearerAuthorization(
                token: accessToken
            )
            
            try request.query.encode([
                "namespace": "dynamic-us",
                "locale": "en_US"
            ])
        }
        
        guard response.status == .ok else {
            throw Abort(
                .badGateway,
                reason: "Failed to fetch Blizzard connected realm"
            )
        }
        
        return try response.content.decode(BlizzardConnectedRealm.self)
    }
    
    func fetchConnectedRealmIndex() async throws -> BlizzardConnectedRealmIndex {
        let accessToken = try await tokenManager.getAccessToken()
        
        let response = try await client.get(
            URI(string: "https://us.api.blizzard.com/data/wow/connected-realm/index")
        ) { request in
            request.headers.bearerAuthorization = BearerAuthorization(
                token: accessToken
            )
            
            try request.query.encode([
                "namespace": "dynamic-us",
                "locale": "en_US"
            ])
        }
        
        guard response.status == .ok else {
            throw Abort(
                .badGateway,
                reason: "Failed to fetch Blizzard connected realm index"
            )
        }
        
        return try response.content.decode(BlizzardConnectedRealmIndex.self)
    }
}
