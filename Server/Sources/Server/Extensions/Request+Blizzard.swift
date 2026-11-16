//
//  Request+Blizzard.swift
//  Server
//
//  Created by Keli'i Martin on 11/14/26.
//

import Vapor

extension Request {
    var blizzardAPI: BlizzardAPIService {
        get throws {
            guard let tokenManager = application.blizzardTokenManager else {
                throw Abort(
                    .serviceUnavailable,
                    reason: "Blizzard authentication is not configured"
                )
            }
            
            return BlizzardAPIService(
                client: client,
                tokenManager: tokenManager
            )
        }
    }
}
