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

extension Application {
    var blizzardAuthService: BlizzardAuthService? {
        get {
            storage[BlizzardAuthServiceKey.self]
        }
        set {
            storage[BlizzardAuthServiceKey.self] = newValue
        }
    }
}
