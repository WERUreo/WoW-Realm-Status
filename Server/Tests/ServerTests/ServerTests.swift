@testable import Server
import VaporTesting
import Testing
import Foundation

@Suite("App Tests")
struct ServerTests {
    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(.GET, "hello", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }
    
    @Test("Test Sample Realm Route")
    func sampleRealm() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(
                .GET,
                "realms/sample",
                afterResponse: { res async throws in
                    #expect(res.status == .ok)
                    
                    let realm = try JSONDecoder().decode(
                        Realm.self,
                        from: Data(res.body.readableBytesView)
                    )
                    
                    #expect(realm.name == "Area 52")
                    #expect(realm.slug == "area-52")
                    #expect(realm.status == .online)
                }
            )
        }
    }
}
