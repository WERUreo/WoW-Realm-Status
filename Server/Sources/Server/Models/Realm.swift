//
//  Realm.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

import Vapor

struct Realm: Content {
    let name: String
    let slug: String
    let status: RealmStatus
}

enum RealmStatus: String, Codable {
    case online
    case offline
    case unknown
}
