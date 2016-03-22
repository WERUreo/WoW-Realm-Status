//
//  Realm.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/20/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import SwiftyJSON

////////////////////////////////////////////////////////////

enum RealmType: String
{
    case PvP = "pvp"
    case PvE = "pve"
    case RP = "rp"
    case RPPvP = "rppvp"
}

////////////////////////////////////////////////////////////

enum Faction: Int
{
    case Alliance = 0
    case Horde = 1
    case Neutral = 2
}

////////////////////////////////////////////////////////////

enum ZoneStatus: Int
{
    case Unknown = -1
    case Idle = 0
    case Populating = 1
    case Active = 2
    case Concluded = 3
}

////////////////////////////////////////////////////////////

class PvPZone
{
    var area: Int
    var controllingFaction: Faction
    var status: ZoneStatus
    var next: NSDate

    init(area: Int, controllingFaction: Faction, status: ZoneStatus, next: NSDate)
    {
        self.area = area
        self.controllingFaction = controllingFaction
        self.status = status
        self.next = next
    }
}

////////////////////////////////////////////////////////////

class Realm
{
    var name: String
    var slug: String
    var type: RealmType
    var status: Bool
    var queue: Bool
    var population: String
    var battlegroup: String
    var locale: NSLocale
    var timezone: NSTimeZone
    var wintergrasp: PvPZone
    var tolBarad: PvPZone
    var connectedRealms = [String]()

    init(json: JSON)
    {
        name = json["name"].stringValue
        slug = json["slug"].stringValue
        type = RealmType(rawValue: json["type"].stringValue)!
        status = json["status"].boolValue
        queue = json["queue"].boolValue
        population = json["population"].stringValue
        battlegroup = json["battlegroup"].stringValue
        locale = NSLocale(localeIdentifier: json["locale"].stringValue)
        timezone = NSTimeZone(name: json["timezone"].stringValue)!

        let wintergraspJSON = json["wintergrasp"]
        wintergrasp = PvPZone(area: wintergraspJSON["area"].intValue, controllingFaction: Faction(rawValue: wintergraspJSON["controlling-faction"].intValue)!, status: ZoneStatus(rawValue: wintergraspJSON["status"].intValue)!, next: NSDate(timeIntervalSince1970: wintergraspJSON["next"].doubleValue))

        let tolBaradJSON = json["tol-barad"]
        tolBarad = PvPZone(area: tolBaradJSON["area"].intValue, controllingFaction: Faction(rawValue: tolBaradJSON["controlling-faction"].intValue)!, status: ZoneStatus(rawValue: tolBaradJSON["status"].intValue)!, next: NSDate(timeIntervalSince1970: tolBaradJSON["next"].doubleValue))

        for realm in json["connected_realms"]
        {
            connectedRealms.append(realm.0)
        }
    }
}