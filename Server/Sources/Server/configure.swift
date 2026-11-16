import Vapor

/// configures your application
func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    let clientID = Environment.get("BLIZZARD_CLIENT_ID")
    let clientSecret = Environment.get("BLIZZARD_CLIENT_SECRET")
    
    let credentials = try? BlizzardCredentials(
        clientID: clientID,
        clientSecret: clientSecret
    )
    
    app.realmCache = RealmCache()

    if let credentials {
        let authService = BlizzardAuthService(
            credentials: credentials,
            client: app.client
        )
        
        app.blizzardAuthService = authService
        
        app.blizzardTokenManager = BlizzardTokenManager(
            authService: authService
        )
    } else {
        app.logger.warning(
            "Blizzard credentials not configured: authentication disabled"
        )
    }
    
    // register routes
    try routes(app)
}
