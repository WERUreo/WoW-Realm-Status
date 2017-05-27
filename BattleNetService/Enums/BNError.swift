//
//  BNError.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/26/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation

public enum BNError : Error
{
    case noAPIKey
    case invalidResponse

    public var localizedDescription: String
    {
        switch self
        {
            case .noAPIKey:         return "There was a problem retrieving the API key"
            case .invalidResponse:  return "There was an invalid response"
        }
    }
}
