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
    case normal = "normal"
    case rp = "roleplaying"

    func toString() -> String
    {
        var returnString: String
        switch self
        {
        case .normal:
            returnString = "normal"
        case .rp:
            returnString = "rp"
        }
        return returnString
    }
}

////////////////////////////////////////////////////////////

enum Faction: Int
{
    case alliance = 0
    case horde = 1
    case neutral = 2

    func toString() -> String
    {
        var returnString: String
        switch self
        {
        case .alliance:
            returnString = "Alliance"
        case .horde:
            returnString = "Horde"
        case .neutral:
            returnString = "Neutral"
        }

        return returnString
    }
}

////////////////////////////////////////////////////////////

enum ZoneStatus: Int
{
    case unknown = -1
    case idle = 0
    case populating = 1
    case active = 2
    case concluded = 3

    func toString() -> String
    {
        var returnString: String
        switch self
        {
        case .unknown:
            returnString = "Unknown"
        case .idle:
            returnString = "Idle"
        case .populating:
            returnString = "Populating"
        case .active:
            returnString = "Active"
        case .concluded:
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
    var next: Date

    init(area: Int, controllingFaction: Faction, status: ZoneStatus, next: Date)
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
    var locale: Locale
    var timezone: TimeZone
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
        locale = Locale(identifier: json["locale"].stringValue)
        timezone = TimeZone(identifier: json["timezone"].stringValue)!

        let wintergraspJSON = json["wintergrasp"]
        wintergrasp = PvPZone(area: wintergraspJSON["area"].intValue, controllingFaction: Faction(rawValue: wintergraspJSON["controlling-faction"].intValue)!, status: ZoneStatus(rawValue: wintergraspJSON["status"].intValue)!, next: Date(timeIntervalSince1970: wintergraspJSON["next"].doubleValue / 1000))

        let tolBaradJSON = json["tol-barad"]
        tolBarad = PvPZone(area: tolBaradJSON["area"].intValue, controllingFaction: Faction(rawValue: tolBaradJSON["controlling-faction"].intValue)!, status: ZoneStatus(rawValue: tolBaradJSON["status"].intValue)!, next: Date(timeIntervalSince1970: tolBaradJSON["next"].doubleValue / 1000))

        for realm in json["connected_realms"]
        {
            connectedRealms.append(realm.0)
        }

        // check if this realm has been added to Favorites

        if let favoriteRealms = Constants.UserDefaults.array(forKey: Constants.FavoriteRealmsKey) as? [String]
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
