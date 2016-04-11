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

    func toString() -> String
    {
        var returnString: String
        switch self
        {
        case .PvP:
            returnString = "PvP"
        case .PvE:
            returnString = "PvE"
        case .RP:
            returnString = "RP"
        case .RPPvP:
            returnString = "RPPvP"
        }
        return returnString
    }
}

////////////////////////////////////////////////////////////

enum Faction: Int
{
    case Alliance = 0
    case Horde = 1
    case Neutral = 2

    func toString() -> String
    {
        var returnString: String
        switch self
        {
        case .Alliance:
            returnString = "Alliance"
        case .Horde:
            returnString = "Horde"
        case .Neutral:
            returnString = "Neutral"
        }

        return returnString
    }
}

////////////////////////////////////////////////////////////

enum ZoneStatus: Int
{
    case Unknown = -1
    case Idle = 0
    case Populating = 1
    case Active = 2
    case Concluded = 3

    func toString() -> String
    {
        var returnString: String
        switch self
        {
        case .Unknown:
            returnString = "Unknown"
        case .Idle:
            returnString = "Idle"
        case .Populating:
            returnString = "Populating"
        case .Active:
            returnString = "Active"
        case .Concluded:
            returnString = "Concluded"
        }
        return returnString
    }
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
    var favorite: Bool = false

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
        wintergrasp = PvPZone(area: wintergraspJSON["area"].intValue, controllingFaction: Faction(rawValue: wintergraspJSON["controlling-faction"].intValue)!, status: ZoneStatus(rawValue: wintergraspJSON["status"].intValue)!, next: NSDate(timeIntervalSince1970: wintergraspJSON["next"].doubleValue / 1000))

        let tolBaradJSON = json["tol-barad"]
        tolBarad = PvPZone(area: tolBaradJSON["area"].intValue, controllingFaction: Faction(rawValue: tolBaradJSON["controlling-faction"].intValue)!, status: ZoneStatus(rawValue: tolBaradJSON["status"].intValue)!, next: NSDate(timeIntervalSince1970: tolBaradJSON["next"].doubleValue / 1000))

        for realm in json["connected_realms"]
        {
            connectedRealms.append(realm.0)
        }

        // check if this realm has been added to Favorites

        if let favoriteRealms = USER_DEFAULTS.arrayForKey(FAVORITE_REALMS_KEY) as? [String]
        {
            for realmSlug in favoriteRealms
            {
                if realmSlug == slug
                {
                    favorite = true
                    break
                }
            }
        }
    }
}