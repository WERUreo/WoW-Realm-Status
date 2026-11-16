//
//  BlizzardRealm.swift
//  Server
//
//  Created by Keli'i Martin on 11/14/26.
//

import Foundation
import Vapor

struct BlizzardRealm: Content {
    let id: Int
    let name: String
    let slug: String
}

struct BlizzardRealmIndexResponse: Decodable {
    let realms: [BlizzardRealm]
}
