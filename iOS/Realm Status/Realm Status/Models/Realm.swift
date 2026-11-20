//
//  Realm.swift
//  Realm Status
//
//  Created by Keli'i Martin on 11/19/26.
//

import Foundation

nonisolated struct Realm: Decodable, Identifiable {
    let id: Int
    let name: String
    let slug: String
    let status: RealmStatus
    let population: String
}

nonisolated enum RealmStatus: String, Decodable {
    case online
    case offline
    case unknown
}
