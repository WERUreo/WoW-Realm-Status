//
//  BlizzardConnectedRealm.swift
//  Server
//
//  Created by Keli'i Martin on 11/14/26.
//

import Foundation
import Vapor

struct BlizzardConnectedRealm: Content {
    let id: Int
    let status: BlizzardRealmValue
    let population: BlizzardRealmValue
    let realms: [BlizzardRealm]
}

struct BlizzardRealmValue: Content {
    let type: String
    let name: String
}

struct BlizzardConnectedRealmIndex: Content {
    let connectedRealms: [BlizzardConnectedRealmReference]
    
    var realmIDs: [Int] {
        connectedRealms.compactMap(\.id)
    }
    
    enum CodingKeys: String, CodingKey {
        case connectedRealms = "connected_realms"
    }
}

struct BlizzardConnectedRealmReference: Content {
    let href: String
    
    var id: Int? {
        guard let url = URL(string: href) else {
            return nil
        }
        
        return Int(url.lastPathComponent)
    }
}
