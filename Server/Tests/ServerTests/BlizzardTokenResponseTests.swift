//
//  BlizzardTokenResponseTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

@testable import Server
import Foundation
import Testing

@Suite("Blizzard Token Response Tests")
struct BlizzardTokenResponseTests {
    @Test("Decode OAuth token response")
    func decodeTokenResponse() throws {
        let json = """
            {
                "access_token": "test-access-token",
                "token_type": "bearer",
                "expires_in": 86399
            }
            """
        
        let response = try JSONDecoder().decode(
            BlizzardTokenResponse.self,
            from: Data(json.utf8)
        )
        
        #expect(response.accessToken == "test-access-token")
        #expect(response.tokenType == "bearer")
        #expect(response.expiresIn == 86399)
    }
}
