//
//  RealmStatusTests.swift
//  Server
//
//  Created by Keli'i Martin on 11/15/26.
//

import Testing
@testable import Server

@Suite("Realm Status Tests")
struct RealmStatusTests {
    @Test(
        "Converts Blizzard status values",
        arguments: [
            ("UP", RealmStatus.online),
            ("DOWN", RealmStatus.offline),
            ("UNKNOWN_VALUE", RealmStatus.unknown),
            ("up", RealmStatus.online)
        ]
    )
    func convertBlizzardStatus(
        input: String,
        expected: RealmStatus
    ) {
        let result = RealmStatus(blizzardStatus: input)
        
        #expect(result == expected)
    }
}
