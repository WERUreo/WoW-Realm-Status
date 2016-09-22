//
//  BattleNetService.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/19/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation

let BASE_URL = "https://us.api.battle.net/wow/"

struct BattleNetService
{
    static let sharedInstance = BattleNetService()

    // MARK: - Private instance variables

    fileprivate var _achievementUrl = "\(BASE_URL)achievement/"
    fileprivate var _auctionDataUrl = "\(BASE_URL)auction/data/"
    fileprivate var _bossUrl = "\(BASE_URL)boss/"
    fileprivate var _characterUrl = "\(BASE_URL)character/"
    fileprivate var _realmStatusUrl = "\(BASE_URL)realm/status"

    // MARK: - Public properties

    var bossUrl: String
    {
        return _bossUrl
    }

    var realmStatusUrl: String
    {
        return _realmStatusUrl
    }

    ////////////////////////////////////////////////////////////
    
    func getAPIKey() -> String?
    {
        var keys: NSDictionary?

        if let path = Bundle.main.path(forResource: "APIKey", ofType: "plist")
        {
            keys = NSDictionary(contentsOfFile: path)
        }

        if let dict = keys
        {
            let apiKey = dict["key"] as? String
            return apiKey
        }

        return nil
    }
}
