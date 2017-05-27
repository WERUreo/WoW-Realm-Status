//
//  PvPZone.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/18/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation

public struct PvPZone
{
    let area: Int
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
