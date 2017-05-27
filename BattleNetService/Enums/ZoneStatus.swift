//
//  ZoneStatus.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/18/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation

public enum ZoneStatus: Int, CustomStringConvertible
{
    case unknown = -1
    case idle = 0
    case populating = 1
    case active = 2
    case concluded = 3

    public var description: String
    {
        switch self
        {
            case .unknown:
                return "Unknown"
            case .idle:
                return "Idle"
            case .populating:
                return "Populating"
            case .active:
                return "Active"
            case .concluded:
                return "Concluded"
        }
    }
}
