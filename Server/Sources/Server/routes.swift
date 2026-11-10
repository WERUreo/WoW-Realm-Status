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
            name: "Area 52",
            slug: "area-52",
            status: .online
        )
    }
}
