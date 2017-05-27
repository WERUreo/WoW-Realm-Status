//
//  Realm.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/22/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Realm
{
    public var name: String
    public var slug: String
    public var type: RealmType
    public var status: Bool
    public var queue: Bool
    public var population: String
    public var battlegroup: String
    public var locale: Locale
    public var timezone: TimeZone
    public var wintergrasp: PvPZone
    public var tolBarad: PvPZone
    public var connectedRealms = [String]()
    public var favorite: Bool = false

    init(json: JSON)
    {
        name = json["name"].stringValue
        slug = json["slug"].stringValue
        type = RealmType(string: json["type"].stringValue)
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
    }
}
