//
//  Factions.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/18/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation

public enum Faction: Int, CustomStringConvertible
{
    case alliance = 0
    case horde = 1
    case neutral = 2

    public var description: String
    {
        switch self
        {
            case .alliance:
                return "Alliance"
            case .horde:
                return "Horde"
            case .neutral:
                return "Neutral"
        }
    }
}
