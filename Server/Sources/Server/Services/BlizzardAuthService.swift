//
//  BlizzardAuthService.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

import Vapor

struct BlizzardAuthService {
    let credentials: BlizzardCredentials
    let client: any Client
    let tokenURL: URI
    
    init(
        credentials: BlizzardCredentials,
        client: any Client,
        tokenURL: URI = URI(string: "https://oauth.battle.net/token")
    ) {
        self.credentials = credentials
        self.client = client
        self.tokenURL = tokenURL
    }
    
    func requestAccessToken() async throws -> BlizzardTokenResponse {
        let response = try await client.post(tokenURL) { request in
            request.headers.basicAuthorization = .init(
                username: self.credentials.clientID,
                password: self.credentials.clientSecret
            )
            
            request.headers.contentType = .urlEncodedForm
            
            try request.content.encode(
                ["grant_type": "client_credentials"],
                as: .urlEncodedForm
            )
        }
        
        guard response.status == .ok else {
            throw Abort(.badGateway, reason: "Blizard authentication failed")
        }
        
        return try response.content.decode(BlizzardTokenResponse.self)
    }
}
