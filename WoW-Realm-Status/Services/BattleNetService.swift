//
//  BattleNetService.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/19/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let BASE_URL = "https://us.api.blizzard.com/wow/"

typealias RetrieveAllRealmsCompletion = (_ realms: [Realm]?, _ favoriteRealms: [Realm]?, _ error: Error?) -> Void
typealias RequestAccessTokenCompletion = (_ accessToken: String?, _ error: Error?) -> Void

struct BattleNetService
{
    static let sharedInstance = BattleNetService()
    
    private init() {}
    
    let realmStatusUrl = "\(BASE_URL)realm/status"

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
    
    ////////////////////////////////////////////////////////////

    fileprivate func getClientIdAndSecret() -> (String, String)?
    {
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "APIKey", ofType: "plist")
        {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = keys
        {
            let id = dict["client_id"] as! String
            let secret = dict["client_secret"] as! String
            return (id, secret)
        }
        
        return nil
    }
    
    ////////////////////////////////////////////////////////////

    func requestAccessToken(_ completion: @escaping RequestAccessTokenCompletion)
    {
        //        https://d9a3c8ed5d554625a935aa3f047adec4:bsBtWFvVoyLLaqQOLM66B6pPfB5EwkXV@us.battle.net/oauth/token?grant_type=client_credentials
        
        let parameters: Parameters =
        [
            "grant_type" : "client_credentials"
        ]
        
        if let (id, secret) = getClientIdAndSecret()
        {
            let credentialData = "\(id):\(secret)".data(using: .utf8)!
            let base64Credentials = credentialData.base64EncodedString()
            let headers = ["Authorization": "Basic \(base64Credentials)"]
            let url = "https://us.battle.net/oauth/token"
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers)
                .validate()
                .responseJSON
            { response in
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        let token = json["access_token"].stringValue
                        completion(token, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    ////////////////////////////////////////////////////////////

    func retrieveAllRealms(_ completion: RetrieveAllRealmsCompletion)
    {
    }
}
