import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("health") { req async -> String in
        "ok"
    }
    
    app.get("realms", "sample") { req async -> Realm in
        Realm(
            id: 5,
            name: "Proudmoore",
            slug: "proudmoore",
            status: .online,
            population: "Full"
        )
    }
    
    app.get("realms", "live") { req async throws -> [BlizzardRealm] in
        return try await req.blizzardAPI.fetchRealmIndex().realms
    }
    
    app.get("realms", "connected", "index") { req async throws -> BlizzardConnectedRealmIndex in
        return try await req.blizzardAPI.fetchConnectedRealmIndex()
    }

    app.get("realms", "connected", ":id") { req async throws -> BlizzardConnectedRealm in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "Invalid connected realm ID")
        }
        
        return try await req.blizzardAPI.fetchConnectedRealm(id: id)
    }
    
    app.get("realms", "aggregated") { req async throws -> [Realm] in
        guard let cache = req.application.realmCache else {
            throw Abort(
                .internalServerError,
                reason: "Realm cache is not configured"
            )
        }
        
        let service = RealmAggregationService(
            blizzardAPI: try req.blizzardAPI
        )
        
        return try await cache.getOrFetch {
            try await service.fetchRealms()
        }
    }
}
