//
//  BNRequestManager.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/22/17.
//  Copyright © 2017 WERUreo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let BNBaseURL = "https://us.api.battle.net/wow/"
private let BNGetRealmStatus = "\(BNBaseURL)realm/status"

public typealias BNRequestRealmsComplete = (_ realms: [Realm]?, _ error: Error?) -> Void

public class BNRequestManager : NSObject
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    public static let shared = BNRequestManager()

    ////////////////////////////////////////////////////////////
    // MARK: - Initializer
    ////////////////////////////////////////////////////////////

    private override init() {}

    ////////////////////////////////////////////////////////////
    // MARK: - Helper functions
    ////////////////////////////////////////////////////////////

    private func getAPIKey() -> String?
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

    ////////////////////////////////////////////////////////////
    // MARK: - Request functions
    ////////////////////////////////////////////////////////////

    public func requestRealms(_ completion: @escaping BNRequestRealmsComplete)
    {
        guard let apiKey = getAPIKey() else
        {
            completion(nil, BNError.noAPIKey)
            return
        }

        let parameters =
        [
            "locale" : "en-US",
            "apikey" : apiKey
        ]

        Alamofire.request(BNGetRealmStatus, method: .get, parameters: parameters).validate().responseJSON
        { response in
            if response.result.isSuccess
            {
                guard let value = response.result.value else
                {
                    completion(nil, BNError.invalidResponse)
                    return
                }

                var realms = [Realm]()
                let json = JSON(value)
                for (_, subJson) in json["realms"]
                {
                    let realm = Realm(json: subJson)
                    realms.append(realm)
                }

                completion(realms, nil)
            }
            else
            {
                completion(nil, response.result.error)
            }
        }
    }
}
