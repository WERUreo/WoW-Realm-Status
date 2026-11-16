//
//  Application+Blizzard.swift
//  Server
//
//  Created by Keli'i Martin on 11/12/26.
//

import Vapor

private struct BlizzardAuthServiceKey: StorageKey {
    typealias Value = BlizzardAuthService
}

private struct BlizzardTokenManagerKey: StorageKey {
    typealias Value = BlizzardTokenManager
}

private struct RealmCacheKey: StorageKey {
    typealias Value = RealmCache
}

extension Application {
    var blizzardAuthService: BlizzardAuthService? {
        get {
            storage[BlizzardAuthServiceKey.self]
        }
        set {
            storage[BlizzardAuthServiceKey.self] = newValue
        }
    }
    
    var blizzardTokenManager: BlizzardTokenManager? {
        get {
            storage[BlizzardTokenManagerKey.self]
        }
        set {
            storage[BlizzardTokenManagerKey.self] = newValue
        }
    }
    
    var realmCache: RealmCache? {
        get {
            storage[RealmCacheKey.self]
        }
        set {
            storage[RealmCacheKey.self] = newValue
        }
    }
}
