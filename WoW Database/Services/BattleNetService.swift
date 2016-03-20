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

    private var _achievementUrl = "\(BASE_URL)achievement/"
    private var _auctionDataUrl = "\(BASE_URL)auction/data/"
    private var _bossUrl = "\(BASE_URL)boss/"
    private var _characterUrl = "\(BASE_URL)character/"
    private var _realmStatusUrl = "\(BASE_URL)realm/status"

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

        if let path = NSBundle.mainBundle().pathForResource("APIKey", ofType: "plist")
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