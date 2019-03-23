//
//  RealmSection.swift
//  WoW-Realm-Status
//
//  Created by Kelii Martin on 3/23/19.
//  Copyright © 2019 WERUreo. All rights reserved.
//

import Foundation

struct RealmSection : Comparable
{
    var index: String
    var realms: [Realm]
    
    static func < (lhs: RealmSection, rhs: RealmSection) -> Bool {
        return lhs.index < rhs.index
    }
    
    static func == (lhs: RealmSection, rhs: RealmSection) -> Bool {
        return lhs.index == rhs.index
    }
}
