//
//  Realm.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

import Vapor

struct Realm: Content {
    let id: Int
    let name: String
    let slug: String
    let status: RealmStatus
    let population: String
}

enum RealmStatus: String, Codable {
    case online
    case offline
    case unknown
    
    init(blizzardStatus: String) {
        switch blizzardStatus.uppercased() {
        case "UP":
            self = .online
        case "DOWN":
            self = .offline
        default:
            self = .unknown
        }
    }
}
