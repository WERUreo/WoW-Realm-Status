//
//  RealmType.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/18/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation

public enum RealmType: CustomStringConvertible
{
    case pvp
    case pve
    case rp
    case rppvp

    ////////////////////////////////////////////////////////////

    public init(string: String)
    {
        switch string
        {
            case "pvp":
                self = .pvp
            case "pve":
                self = .pve
            case "rp":
                self = .rp
            case "rppvp":
                self = .rppvp
            default:
                self = .pvp
        }
    }

    ////////////////////////////////////////////////////////////

    public var description: String
    {
        switch self
        {
            case .pvp:
                return "PvP"
            case .pve:
                return "PvE"
            case .rp:
                return "RP"
            case .rppvp:
                return "RPPvP"
        }
    }
}
